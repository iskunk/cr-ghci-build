#!/usr/bin/perl
# ninja-filter.pl
#
# Script to reduce the volume of terminal output of ninja(1), for the
# benefit of GitHub's workflow log view page. During a workflow run, the
# log view tends to cut off around 15K lines. This script elides most of
# the uneventful [N/M] step lines, while still letting through compiler
# warnings and other messages.
#

use strict;
use warnings;

$| = 1;  # enable autoflush

my $step_line = '';
my $in_abbr = 0;
my $in_msg = 0;

while (<STDIN>)
{
	if (m:^\[(\d+)/(\d+)\]:)
	{
		my $n = $1 + 0; my $m = $2 + 0;
		$step_line = $_;

		$in_msg = 0;

		if ($n == 1 || $n % 100 == 0 || $n >= $m - 50)
		{
			print;
			$in_abbr = 0;
		}
		elsif (! $in_abbr)
		{
			print "...\n";
			$in_abbr = 1;
		}
	}
	elsif (/^ninja:/)
	{
		print;
	}
	else
	{
		print $step_line if $in_abbr && ! $in_msg;
		print;
		$in_abbr = 0;
		$in_msg = 1;
	}
}

# end ninja-filter.pl
