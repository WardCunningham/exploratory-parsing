#!/usr/bin/perl

# usage
#   head json | perl print-head.pl

print "<table>\n";
for (<>) {
	last if /"metrics":/;
	next unless /"(.*?)": (.*)$/;
	print "<tr><td>$1<td>$2\n";
}
print "</table>\n";