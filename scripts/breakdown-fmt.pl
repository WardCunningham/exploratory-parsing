#!/usr/bin/perl

# usage
#   cat tally.dot | perl ../scripts/breakdown-fmt.pl run file | dot -Tsvg -otally.svg
$run = $ARGV[0];
$file = $ARGV[1];
$dir = "../runs/$run/data";

# compute offsets in data for single file in breakdown
$offset = 0;
for (<$dir/*>) {
	last if $_ =~ /$file/;
	$offset += -s $_;
}
print STEDERR "$dir $file $offset\n";

# format dot output (easier here than in c)
for (<STDIN>) {
	s/javascript:top\.samples\(\[(.*?)\]\);/offset()/geo;
	s/".*?"/newline()/geo;
	s/label = "(\d+)", /bold()/geo;
	s/label = "(\d+)"/comma()/geo;
	recolor() if /^}/;
	print;
}

# relocate offset references to recent run
sub offset {
	my @args;
	for (split(/,/,$1)) {
		push(@args, $1+$offset . '-' . $2) if /(\d+)-(\d+)/;
	}
	"http://localhost:8080/runs/$run/offsets?offsets=" . join(',',@args)
}

# escape html
# break node names at space
sub newline {
	$_ = $&;
	s/&/&amp;/g;
	s/</&lt;/g;
	s/ |_/\\n/g;
	$o{$_}++ if /\b(other)\b/;
	$a{$_}++ if /\b(all|any)\b/;
	$_;
}

# bold lines for big numbers

sub bold {
	($1 < 1000) ? $& : $& . "penwidth=3, "
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
    for (keys %a) {
        print "$_ [fillcolor=pink];\n";
    }
    print "\"/root/\" [shape=point fillcolor=black];\n";
}
