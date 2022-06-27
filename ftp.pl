#!/usr/bin/env perl

use strict;
use warnings;

use Net::FTP;

use FindBin qw($RealBin);
use lib "$RealBin/";

use Runner;

use constant PORT         => 21;
use constant FTP_TIMEOUT  => 3;

my $logfile = 'out/ftp.log';
my $runner = Runner->new(Port => PORT);

open(LOG, '>>', $logfile) or die "e: $!\n";
LOG->autoflush();

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
            print LOG "$ip: ", join(';', @files), "\n";
            print "$ip\n";
            print "$_\n" for (@files);
        })
    }

  End:
    $c->quit;
});

close(LOG);
