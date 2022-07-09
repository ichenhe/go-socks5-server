package main

import (
	"fmt"
	"github.com/things-go/go-socks5"
	"log"
	"os"
	"strconv"
	"strings"
)

type conf struct {
	Port  int
	Auths []auth
}

type auth struct {
	Username string
	Password string
}

func readConf() *conf {
	conf := conf{
		Port:  1080,
		Auths: nil,
	}

	if portStr := os.Getenv("GO_SOCKS_PORT"); portStr != "" {
		if p, err := strconv.Atoi(portStr); err != nil {
			panic(fmt.Errorf("failed to parse port: %w", err))
		} else {
			conf.Port = p
		}
	}
	if authStr := os.Getenv("GO_SOCKS_AUTHS"); authStr != "" {
		authFragment := strings.Split(authStr, ":")
		if len(authFragment)%2 != 0 {
			panic(fmt.Errorf("user name and password must appear in pairs"))
		}
		auths := make([]auth, 0, len(authFragment)/2)
		for i := 0; i < len(authFragment); i++ {
			auths = append(auths, auth{Username: authFragment[i], Password: authFragment[i+1]})
			i++
		}
		conf.Auths = auths
	}

	return &conf
}

func main() {
	conf := readConf()

	options := []socks5.Option{socks5.WithLogger(socks5.NewLogger(log.New(os.Stdout, "socks5: ", log.LstdFlags)))}
	if len(conf.Auths) > 0 {
		credentials := socks5.StaticCredentials{}
		for _, auth := range conf.Auths {
			credentials[auth.Username] = auth.Password
		}
		options = append(options, socks5.WithAuthMethods([]socks5.Authenticator{socks5.UserPassAuthenticator{
			Credentials: credentials,
		}}))
		log.Default().Printf("%d auth user", len(conf.Auths))
	} else {
		log.Default().Printf("No auth")
	}

	server := socks5.NewServer(options...)

	log.Default().Printf("Start listening proxy service on :%d", conf.Port)
	if err := server.ListenAndServe("tcp", ":"+strconv.Itoa(conf.Port)); err != nil {
		panic(err)
	}
}
