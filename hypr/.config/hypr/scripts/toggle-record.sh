#!/bin/bash

if pgrep wf-recorder > /dev/null; then
    pkill wf-recorder
else
    region=$(slurp)
    wf-recorder -g "$region" -f ~/data/videos/$(date +%Y%m%d_%H%M%S).mp4
fi