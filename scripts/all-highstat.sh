echo 0x00; time for i in {1..1000}; do ./run.sh $'\x00'; done &>> logs-highstat/0x00.txt
echo 0xff; time for i in {1..1000}; do ./run.sh $'\xff'; done &>> logs-highstat/0xff.txt
