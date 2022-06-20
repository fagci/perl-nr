#!/usr/bin/env perl

use strict;
use warnings;
use threads;
use Net::FTP;
use IO::Socket::INET;

use FindBin qw($RealBin);
use lib "$RealBin/";

use Gen;

use constant PORT         => 21;
use constant CONN_TIMEOUT => 0.75;
use constant FTP_TIMEOUT  => 3;

sub has_ftp {
    my $s = IO::Socket::INET->new(
        PeerAddr => shift,
        PeerPort => PORT,
        Timeout  => CONN_TIMEOUT,
    ) or return 0;

    close($s);
    return 1;
}

sub try_ftp {
    my $ip = shift;
    my $c  = Net::FTP->new(
        $ip,
        Port    => PORT,
        Timeout => FTP_TIMEOUT,
    ) or return 0;

    unless ( $c->login ) {
        $c->quit;
        return 0;
    }

    my @files = $c->ls;

    if (@files) {
        print "$ip\n";
        print "$_\n" for (@files);
    }

    $c->quit;
    return 1;
}

sub scan {
    while ( my $ip = Gen::ip() ) {
        next unless has_ftp $ip;
        try_ftp $ip;
    }
}

threads->new( \&scan ) for ( 0 .. 512 );

$_->join for ( threads->list );
