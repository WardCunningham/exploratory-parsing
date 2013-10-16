# usage:
#   sh scripts/breakdown.sh

rm -f breakdown.html
run=`ls runs | tail -1`
echo breakdown run $run
ls -tr runs/$run/data | while read data
do echo running $data
	cat runs/$run/data/$data | (cd breakdown.d; ../runs/$run/parse; cat tally.dot | perl ../scripts/breakdown-fmt.pl $run $data | dot -Tsvg -otally.svg 2>output.log)
	rpm=`perl -e 'print "<a href=http://rpm.newrelic.com/accounts/$1/applications/$2>rpm</a>" if "'$data'"=~/(\d+).*?(\d+)/'`
	(echo '<h1>' $data $rpm'</h1>'; cat breakdown.d/tally.svg) >> breakdown.html
done