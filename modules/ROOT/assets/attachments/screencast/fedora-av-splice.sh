#!/bin/bash
# 2008-06-20
# fedora-av-splice.sh
# Simple shellscript to mix theora video+audio using gstreamer pipeline
# Takes 3 arguments wavfile theoravideo output-theora-video

if [ $# -lt 3 ] ; then
  echo "Usage: $0 wavfile theora-video output-video"
  echo "Ex: $0 english-audio.wav desktop-recording.ogg english-desktop-video.ogg"
else
   gst-launch-0.10 \
     filesrc location=$2 \! decodebin name="video" \
     filesrc location=$1 \! decodebin name="audio" \
     audio. \! queue \! audioconvert \! vorbisenc \! queue \! mux. \
     video. \! queue \! ffmpegcolorspace \! theoraenc quality=32 \! oggmux name=mux \! filesink location="$3"

fi
