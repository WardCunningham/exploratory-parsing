#!/usr/bin/perl

# usage
#   cat tally.dot | perl ../scripts/breakdown-fmt.pl data/dir file | dot -Tsvg -otally.svg
$dir = $ARGV[0];
$file = $ARGV[1];

# compute offsets in data for single file in breakdown
$offset = 0;
for (<$dir/*>) {
	last if $_ =~ /$file/;
	$offset += -s $_;
}

# format dot output (easier here than in c)
for (<STDIN>) {
	s/".*?"/newline()/geo;
	s/label = "(\d+)"/comma()/geo;
	recolor() if /^}/;
	print;
}

# escape html
# break node names at space
sub newline {
	$_ = $&;
	s/&/&amp;/g;
	s/</&lt;/g;
	s/ |_/\\n/g;
	$o{$_}++ if /\bother\b/;
	$_;
}

# add commas to number
sub comma {
	$_ = $1;
	s/(\d)(?=(\d{3})+(\D|$))/$1\,/g;
	"label = \"$_\"";
}

# color other-nodes gray
sub recolor {
    for (keys %o) {
        print "$_ [fillcolor=lightgray];\n";
    }
}
