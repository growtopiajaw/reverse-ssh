#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

if ! command -v git &> /dev/null
then
    DEV_VER="development"
else
    DEV_VER="dev-$(git rev-parse --short HEAD)"
fi

VERSION=${VERSION:=$DEV_VER}

build() {
    EXT=""
    [[ $GOOS = "windows" ]] && EXT=".exe"
    echo "Building ${GOOS} ${GOARCH}"
    CGO_ENABLED=0 go build \
        -trimpath \
        -ldflags="-s -w -X 'github.com/Fahrj/reverse-ssh/cmd.Version=$VERSION'" \
        -o ./bin/reversessh-${GOOS}-${GOARCH}v${GOARM}${EXT} .
}

### multi arch binary build
GOOS=linux GOARCH=arm GOARM=5 build
GOOS=linux GOARCH=arm GOARM=6 build
GOOS=linux GOARCH=arm GOARM=7 build
