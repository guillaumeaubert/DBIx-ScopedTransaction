#!perl -T

use strict;
use warnings;

use Test::More tests => 1;


BEGIN
{
	use_ok( 'DBIx::ScopedTransaction' );
}

diag( "Testing DBIx::ScopedTransaction $DBIx::ScopedTransaction::VERSION, Perl $], $^X" );
