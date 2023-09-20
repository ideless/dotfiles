#!/bin/bash

INPUT=$1
OUTPUT=${INPUT%.*}-compressed.mp4

ffmpeg -i "$INPUT" -vcodec libx265 -crf 28 "$OUTPUT"
