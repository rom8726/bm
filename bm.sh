#!/bin/sh

bm() {
  if [ "$1" = "-s" ]; then
    command bm-util -s "$2"
  elif [ "$1" = "-d" ]; then
    command bm-util -d "$2"
  elif [ "$1" = "-l" ]; then
    command bm-util -l
  else
    cd "$(command bm-util go "$1")"
  fi
}
