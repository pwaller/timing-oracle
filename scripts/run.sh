echo ----
chrt -r 99 taskset 0x4 /usr/bin/time -f"%c %w %R %F" ./test "$1"
