#!/bin/sh

SEARCH_DIR=${1:-.}

echo "Processing jpeg files..."

find ${SEARCH_DIR} -iname '*.jpeg' -o -iname '*.jpg' -print0 | xargs -0 -n 1 -P $(nproc) jpegoptim --strip-all --preserve --totals -v

echo "Processing png files..."

find ${SEARCH_DIR} -iname '*.png' -print0 | xargs -0 -n 1 -P $(nproc) optipng

echo "Finished!"
