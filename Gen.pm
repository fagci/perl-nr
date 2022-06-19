#!/usr/bin/env perl

package Gen;

my $iips = 0x1000000;
my $iipe = 0xE0000000;
my $rmax = $iipe - $iips + 1;

sub ip() {
    my $intip = $iips + int( rand($rmax) );
    return ip()
      if ( $intip >= 0xAFFFFFF && $intip <= 0xAFFFFFF )
      || ( $intip >= 0x647FFFFF && $intip <= 0x647FFFFF )
      || ( $intip >= 0x7FFFFFFF && $intip <= 0x7FFFFFFF )
      || ( $intip >= 0xA9FEFFFF && $intip <= 0xA9FEFFFF )
      || ( $intip >= 0xAC1FFFFF && $intip <= 0xAC1FFFFF )
      || ( $intip >= 0xC0000007 && $intip <= 0xC0000007 )
      || ( $intip >= 0xC00000AB && $intip <= 0xC00000AB )
      || ( $intip >= 0xC00002FF && $intip <= 0xC00002FF )
      || ( $intip >= 0xC0A8FFFF && $intip <= 0xC0A8FFFF )
      || ( $intip >= 0xC613FFFF && $intip <= 0xC613FFFF )
      || ( $intip >= 0xC63364FF && $intip <= 0xC63364FF )
      || ( $intip >= 0xCB0071FF && $intip <= 0xCB0071FF )
      || ( $intip >= 0xFFFFFFFF && $intip <= 0xFFFFFFFF );

    return join( '.', unpack( 'C*', pack( 'N', $intip ) ) );
}

1;
