#!/bin/sh

export CGO_ENABLED=1
export CFLAGS='-w -s -O3'
export CGO_CFLAGS="$CFLAGS"
export CGO_CPPFLAGS="$CFLAGS"
export CGO_CXXFLAGS="$CFLAGS"
export CGO_FFLAGS="$CFLAGS"
export CGO_LDFLAGS="$CFLAGS"

# read -p 'Пожалуйста, введите номер версии: ' ver

echo 'Компиляция windows-x86 бинарника...'
mkdir -p ./builds/windows/Infinite-Bomber-x86
GOOS=windows GOARCH=386 go build -o ./builds/windows/Infinite-Bomber-x86/infinite-bomber.exe -gcflags="all=-trimpath=$HOME" -asmflags="all=-trimpath=$HOME" -ldflags="-s -w"

# rcedit.exe ./builds/windows/Infinite-Bomber-x86/infinite-bomber.exe --set-version-string "Infinite Bomber v$ver" --set-file-version $ver --set-product-version $ver --set-icon ./icon.ico

echo 'Копирование services.yaml...'
cp ./services.yaml ./builds/windows/Infinite-Bomber-x86/

echo 'Копирование файлов тора...'
rm -r ./tor-files/Data/data*
mkdir -p ./builds/windows/Infinite-Bomber-x86/tor
cp -r ./tor-files/* ./builds/windows/Infinite-Bomber-x86/tor

echo 'Компиляция windows-x64 бинарника...'
mkdir -p ./builds/windows/Infinite-Bomber-x64
GOOS=windows GOARCH=amd64 go build -o ./builds/windows/Infinite-Bomber-x64/infinite-bomber.exe -gcflags="all=-trimpath=$HOME" -asmflags="all=-trimpath=$HOME" -ldflags="-s -w"

# rcedit.exe ./builds/windows/Infinite-Bomber-x64/infinite-bomber.exe --set-version-string "Infinite Bomber v$ver" --set-file-version $ver --set-product-version $ver --set-icon ./icon.ico

echo 'Копирование services.yaml...'
cp ./services.yaml ./builds/windows/Infinite-Bomber-x64/

echo 'Копирование файлов тора...'
rm -r ./tor-files/Data/data*
mkdir -p ./builds/windows/Infinite-Bomber-x64/tor
cp -r ./tor-files/* ./builds/windows/Infinite-Bomber-x64/tor

echo 'Готово!'
