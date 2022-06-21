#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($RealBin);
use lib "$RealBin/";

use Runner;

my $runner = Runner->new(Port => 80);

$runner->run(sub {
    my ($ip, $s) = @_;
    print $s "GET / HTTP/1.1\r\n";
    print $s "Host: $ip\r\n";
    print $s "User-Agent: Mozilla/5.0\r\n";
    print $s "\r\n";

    while(<$s>) {
        return if m/^HTTP\S+ [345]/;
        if (m/<title>([^<]+)/i) {
            print "$ip: $1\n";
            return;
        }
    }
});
