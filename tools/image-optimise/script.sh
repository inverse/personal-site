#!/bin/sh

SEARCH_DIR=${1:-.}

find ${SEARCH_DIR} -iname '*.jpeg' -o -iname '*.jpg' |  xargs jpegoptim --max=90 --strip-all --preserve --totals -v


find ${SEARCH_DIR} -iname '*.png' |  xargs optipng
