#!/usr/bin/env perl

package Runner;

use strict;
use warnings;

use threads;
use Thread::Semaphore;
use IO::Socket::INET;

use FindBin qw($RealBin);
use lib "$RealBin/";

use Gen;

our $sem = Thread::Semaphore->new();

sub locked {
    my ($self, $fn) = @_;
    $sem->down;
    $fn->();
    $sem->up;
}

sub new {
    my ($class, %args) = @_;

    bless {
        Port => $args{Port},
        Threads => $args{Threads} // 512,
        ConnTimeout => $args{ConnTimeout} // 0.75,
    }, $class;
}

sub scan {
    my $self = shift;
    while ( my $ip = Gen::ip ) {
        my $s = IO::Socket::INET->new(
            PeerAddr => $ip,
            PeerPort => $self->{Port},
            Timeout  => $self->{ConnTimeout},
        ) or next;
        $self->{fn}($ip, $s);
        close $s;
    }
}

sub run {
    my $self = shift;
    $self->{fn} = shift;

    threads->new( sub{$self->scan(@_)} ) for ( 0 .. $self->{Threads} );

    $_->join for ( threads->list );
}

1;
