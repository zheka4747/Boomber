#!/bin/sh

export CGO_ENABLED=1
export CFLAGS='-w -s -O3'
export CGO_CFLAGS="$CFLAGS"
export CGO_CPPFLAGS="$CFLAGS"
export CGO_CXXFLAGS="$CFLAGS"
export CGO_FFLAGS="$CFLAGS"
export CGO_LDFLAGS="$CFLAGS"

export llvm_bin=$ANDROID_HOME/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/bin/

echo 'Компиляция android-arm бинарника...'
export CC=$llvm_bin/armv7a-linux-androideabi16-clang
export CXX=$llvm_bin/armv7a-linux-androideabi16-clang++

mkdir -p ./builds/android/Infinite-Bomber-arm
GOOS=android GOARCH=arm GOARM=7 go build -o ./builds/android/Infinite-Bomber-arm/infinite-bomber -gcflags="all=-trimpath=$HOME" -asmflags="all=-trimpath=$HOME" -ldflags="-s -w"

echo 'Копирование services.yaml...'
cp ./services.yaml ./builds/android/Infinite-Bomber-arm/

echo 'Копирование файлов тора...'
rm -r ./tor-files/Data/data*
mkdir -p ./builds/android/Infinite-Bomber-arm/tor
cp -r ./tor-files/Data ./builds/android/Infinite-Bomber-arm/tor/
cp -r ./tor-files/torrc ./builds/android/Infinite-Bomber-arm/tor/

echo 'Компиляция android-arm64 бинарника...'
export CC=$llvm_bin/aarch64-linux-android21-clang
export CXX=$llvm_bin/aarch64-linux-android21-clang++

mkdir -p ./builds/android/Infinite-Bomber-arm64
GOOS=android GOARCH=arm64 go build -o ./builds/android/Infinite-Bomber-arm64/infinite-bomber -gcflags="all=-trimpath=$HOME" -asmflags="all=-trimpath=$HOME" -ldflags="-s -w"

echo 'Копирование services.yaml...'
cp ./services.yaml ./builds/android/Infinite-Bomber-arm64/

echo 'Копирование файлов тора...'
rm -r ./tor-files/Data/data*
mkdir -p ./builds/android/Infinite-Bomber-arm64/tor
cp -r ./tor-files/Data ./builds/android/Infinite-Bomber-arm64/tor/
cp -r ./tor-files/torrc ./builds/android/Infinite-Bomber-arm64/tor/

echo 'Компиляция android-x86 бинарника...'
export CC=$llvm_bin/i686-linux-android16-clang
export CXX=$llvm_bin/i686-linux-android16-clang++

mkdir -p ./builds/android/Infinite-Bomber-x86
GOOS=android GOARCH=386 go build -o ./builds/android/Infinite-Bomber-x86/infinite-bomber -gcflags="all=-trimpath=$HOME" -asmflags="all=-trimpath=$HOME" -ldflags="-s -w"

echo 'Копирование services.yaml...'
cp ./services.yaml ./builds/android/Infinite-Bomber-x86/

echo 'Копирование файлов тора...'
rm -r ./tor-files/Data/data*
mkdir -p ./builds/android/Infinite-Bomber-x86/tor
cp -r ./tor-files/Data ./builds/android/Infinite-Bomber-x86/tor/
cp -r ./tor-files/torrc ./builds/android/Infinite-Bomber-x86/tor/

echo 'Компиляция android-x64 бинарника...'
export CC=$llvm_bin/x86_64-linux-android21-clang
export CXX=$llvm_bin/x86_64-linux-android21-clang++

mkdir -p ./builds/android/Infinite-Bomber-x64
GOOS=android GOARCH=amd64 go build -o ./builds/android/Infinite-Bomber-x64/infinite-bomber -gcflags="all=-trimpath=$HOME" -asmflags="all=-trimpath=$HOME" -ldflags="-s -w"

echo 'Копирование services.yaml...'
cp ./services.yaml ./builds/android/Infinite-Bomber-x64/

echo 'Копирование файлов тора...'
rm -r ./tor-files/Data/data*
mkdir -p ./builds/android/Infinite-Bomber-x64/tor
cp -r ./tor-files/Data ./builds/android/Infinite-Bomber-x64/tor/
cp -r ./tor-files/torrc ./builds/android/Infinite-Bomber-x64/tor/

echo 'Готово!'
