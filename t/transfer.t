#!/usr/bin/perl6

use v6;

# a transfer function test

use Test;
use Coro::Simple;

plan 6;

sub transfer (&generator) {
    yield &generator; # 'transfer' is just a alias for 'yield'
}

my $ping;
my $pong;

my &ping = coro -> $msg {
    for ^3 -> $i {
	say [ $msg, $i ];
	sleep 0.5;
	ok transfer $pong;
    }
};

my &pong = coro -> $msg {
    for ^3 -> $i {
	say [ $msg, $i ];
	sleep 0.5;
	ok transfer $ping;
    }
};

$ping = ping "Ping!";
$pong = pong "Pong!";

# a small / useful scheduler-like chunk
(from $ping).map(&from).map: { &^generator( ) };

# for from $ping -> $coro {
#     for from $coro -> $next {
# 	$next( );
#     }
# }

# end of test