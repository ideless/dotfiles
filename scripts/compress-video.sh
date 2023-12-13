#!/bin/bash

PS3="Select an MKV file (use a number): "
select file in *.mkv; do
    if [ -n "$file" ]; then
        INPUT=$file
        OUTPUT=${file%.*}-compressed.mp4

        echo "Compressing $INPUT to $OUTPUT"

        ffmpeg -i "$INPUT" -vcodec libx265 -crf 28 "$OUTPUT"

        break
    else
        echo "Invalid selection. Please try again."
    fi
done
