#!/bin/sh

if [ $KDEWM == "/usr/bin/bspwm" ]; then
	picom -b --experimental-backends &
fi
