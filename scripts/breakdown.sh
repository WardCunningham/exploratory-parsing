# usage:
#   sh scripts/breakdown.sh data/NewRelicMGI

rm -f breakdown.html
run=`ls runs | tail -1`
ls -tr $1 | while read data
do echo running $data
	cat $1/$data | (cd breakdown.d; ../runs/$run/parse; cat tally.dot | perl ../scripts/breakdown-fmt.pl ../$1 $data | dot -Tsvg -otally.svg 2>output.log)
	rpm=`perl -e 'print "<a href=http://rpm.newrelic.com/accounts/$1/applications/$2>rpm</a>" if "'$data'"=~/(\d+).*?(\d+)/'`
	label=`(cd $1; ls -l $data | perl -pe 's/.*? +.*? +.*? +.*? +.*? +//')`
	(echo '<h1>' $label $rpm'</h1>'; cat breakdown.d/tally.svg) >> breakdown.html
done