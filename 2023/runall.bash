echo ''
echo '                  Part 1           Part 2            Time'
echo ''
start=`date +%s%6N`
RUNNING=0;
for i in {1..25}
do
  if [ -f "day$i.pl" ]
  then
    O=`perl day$i.pl input/day$i.txt`
    Z=`echo $O | grep -Eo '[.0-9]+$'`
    RUNNING=`perl -e "print $RUNNING + $Z"`
    perl -e "printf ' Day %2d ', $i"
    echo "$O"
  fi
done
end=`date +%s%6N`

perl -e 'printf "\n Running Total                            %15.9f", $ARGV[0]' $RUNNING
perl -e 'printf "\n Wall clock total                         %15.9f\n\n", ($ARGV[1]-$ARGV[0])/1e6' $start $end
