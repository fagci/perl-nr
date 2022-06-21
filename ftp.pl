#!/usr/bin/env perl

use strict;
use warnings;

use Net::FTP;

use FindBin qw($RealBin);
use lib "$RealBin/";

use Runner;

use constant PORT         => 21;
use constant FTP_TIMEOUT  => 3;

my $runner = Runner->new(Port => PORT);

$runner->run(sub {
    my ($ip) = @_;
    my $c  = Net::FTP->new(
        $ip,
        Port    => PORT,
        Timeout => FTP_TIMEOUT,
    ) or return;

    goto End unless $c->login;

    my @files = grep { !/^\.{1,2}$/ } $c->ls;

    if (@files) {
        $runner->locked(sub {
            print "$ip\n";
            print "$_\n" for (@files);
        })
    }

  End:
    $c->quit;
});
