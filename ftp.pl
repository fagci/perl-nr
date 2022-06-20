#!/usr/bin/env perl

use strict;
use threads;
use Net::FTP;

use FindBin qw($RealBin);
use lib "$RealBin/";

use Gen;

sub scan {
    while ( my $ip = Gen::ip() ) {
        my $s = IO::Socket::INET->new(
            PeerAddr => $ip,
            PeerPort => 21,
            Timeout  => 0.75,
        ) or next;
        close($s);

        my $c = Net::FTP->new( $ip, Timeout => 2 ) or next;

        if ( $c->login ) {
            my @ff = $c->ls();

            if (@ff) {
                print "$ip\n";
                print "$_\n" for (@ff);
            }
        }

        $c->quit;
    }
}

threads->new( \&scan ) for ( 0 .. 512 );

$_->join for ( threads->list );
