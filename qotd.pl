#!/usr/bin/env perl

use strict;
use warnings;

use Socket qw[ SOL_SOCKET SO_RCVTIMEO ];

use FindBin qw($RealBin);
use lib "$RealBin/";

use Runner;

Runner
->new(Port => 17)
->run(sub {
    my ($ip, $s) = @_;

    my $timeval = pack 'l!l!', 2, 0;
    $s->setsockopt(SOL_SOCKET, SO_RCVTIMEO, $timeval) or die $!;

    Runner->locked(sub {
        print "$ip:\n$_\n" while <$s>;
    });
});
