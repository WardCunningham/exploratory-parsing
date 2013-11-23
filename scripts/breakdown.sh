# usage:
#   sh scripts/breakdown.sh

rm -f breakdown.html
run=`ls runs | tail -1`
echo breakdown run $run
ls runs/$run/data | while read data
do echo running $data
	cat runs/$run/data/$data | (cd breakdown.d; ../runs/$run/parse; cat tally.dot | perl ../scripts/breakdown-fmt.pl $run $data | dot -Tsvg -otally.svg 2>output.log)
	rpm=`perl -e 'print "<a href=http://rpm.newrelic.com/accounts/$1/applications/$2/metrics/explore_metrics target=\"_blank\">rpm</a>" if "'$data'"=~/(\d+).*?(\d+)/'`
	(	echo '<h1>' $data $rpm'</h1>';
		head -n 20 runs/$run/data/$data | perl scripts/print-head.pl;
		echo '<pre>'
		cat runs/$run/data/$data |
			perl -n -e 'print "$1\n" if /^\s*"([^"]+)",?\s$/' |
			perl -MList::Util -e 'print List::Util::shuffle <>' |
			ruby scripts/count.rb 100 2>&1
		echo '</pre>'
		cat breakdown.d/tally.svg
	) >> breakdown.html
done