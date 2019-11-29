#!/bin/sh

export CGO_ENABLED=1
export CFLAGS='-w -s -O3'
export CGO_CFLAGS="$CFLAGS"
export CGO_CPPFLAGS="$CFLAGS"
export CGO_CXXFLAGS="$CFLAGS"
export CGO_FFLAGS="$CFLAGS"
export CGO_LDFLAGS="$CFLAGS"

echo 'Компиляция linux-x86 бинарника...'
mkdir -p ./builds/linux/Infinite-Bomber-x86
GOOS=linux GOARCH=386 CGO_ENABLED=1 go build -o ./builds/linux/Infinite-Bomber-x86/infinite-bomber -gcflags="all=-trimpath=$HOME" -asmflags="all=-trimpath=$HOME" -ldflags="-s -w"

echo 'Копирование services.yaml...'
cp ./services.yaml ./builds/linux/Infinite-Bomber-x86/

echo 'Копирование файлов тора...'
rm -r ./tor-files/Data/data*
mkdir -p ./builds/linux/Infinite-Bomber-x86/tor
cp -r ./tor-files/Data ./builds/linux/Infinite-Bomber-x86/tor/
cp -r ./tor-files/torrc ./builds/linux/Infinite-Bomber-x86/tor/

echo 'Компиляция linux-x64 бинарника...'
mkdir -p ./builds/linux/Infinite-Bomber-x64
GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build -o ./builds/linux/Infinite-Bomber-x64/infinite-bomber -gcflags="all=-trimpath=$HOME" -asmflags="all=-trimpath=$HOME" -ldflags="-s -w"

echo 'Копирование services.yaml...'
cp ./services.yaml ./builds/linux/Infinite-Bomber-x64/

echo 'Копирование файлов тора...'
rm -r ./tor-files/Data/data*
mkdir -p ./builds/linux/Infinite-Bomber-x64/tor
cp -r ./tor-files/Data ./builds/linux/Infinite-Bomber-x64/tor/
cp -r ./tor-files/torrc ./builds/linux/Infinite-Bomber-x64/tor/

echo 'Готово!'
