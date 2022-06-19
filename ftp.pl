#!/usr/bin/env perl

use strict;
use threads;
use Net::FTP;

use FindBin qw($RealBin);
use lib "$RealBin/";

use Gen;

sub scan {
    while ( my $ip = Gen::ip() ) {
        my $c = Net::FTP->new( $ip, Timeout => 1 ) or next;

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

my @threads;

for ( 0 .. 1024 ) {
    push @threads, threads->new( \&scan );
}

$_->join() for (@threads);
