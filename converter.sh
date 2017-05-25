#!/bin/sh
set -eu

mkdir high
HandBrakeCLI --input $1 \
              --output high/video.mp4 \
              -E ca_aac \
              -e x264 \
              --encoder-profile high \
              --encoder-level 4.0 \
              -r 29.97 \
              --width 1280 \
              --maxWidth 1280 \
              --height 720 \
              --maxHeight 720 \
              --crop 0:0:0:0 \
              --loose-crop \
              --non-anamorphic \
              --keep-display-aspect \
              -b 6000 \
              -B 128

mkdir med
HandBrakeCLI --input $1 \
              --output med/video.mp4\
              -E ca_aac \
              -e x264 \
              --encoder-profile main \
              --encoder-level 3.1 \
              -r 29.97 \
              --width 960 \
              --maxWidth 960 \
              --height 540 \
              --maxHeight 540 \
              --crop 0:0:0:0 \
              --loose-crop \
              --non-anamorphic \
              --keep-display-aspect \
              -b 2000 \
              -B 96

mkdir low
HandBrakeCLI --input $1 \
              --output low/video.mp4 \
              -E ca_aac \
              -e x264 \
              --encoder-profile baseline \
              --encoder-level 3.0 \
              -r 15 \
              --width 480 \
              --maxWidth 480 \
              --height 270 \
              --maxHeight 270 \
              --crop 0:0:0:0 \
              --loose-crop \
              --non-anamorphic \
              --keep-display-aspect \
              -b 365 \
              -B 64

for QUALITY_DIR in high med low; do
    cd ${QUALITY_DIR}
    mediafilesegmenter video.mp4
    mediafilesegmenter -I video.mp4
    cd ..
done

variantplaylistcreator -o video.m3u8 \
    high/prog_index.m3u8 high/video.plist -iframe-url high/iframe_index.m3u8 \
    med/prog_index.m3u8 med/video.plist   -iframe-url med/iframe_index.m3u8 \
    low/prog_index.m3u8 low/video.plist   -iframe-url low/iframe_index.m3u8
