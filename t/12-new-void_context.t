#!perl -T

use strict;
use warnings;

use DBI;
use DBIx::ScopedTransaction;
use File::Spec;
use Test::Exception;
use Test::More tests => 5;


ok(
	my $dbh = DBI->connect(
		"dbi:SQLite::memory:",
		'',
		'',
		{
			RaiseError => 1,
		}
	),
	'Create connection to a SQLite database.',
);

lives_ok
(
	sub
	{
		open( STDERR, '>', File::Spec->devnull() ) || die "could not open STDERR: $!";
	},
	'Redirect STDERR to destroy transaction object silently.',
);

dies_ok(
	sub
	{
		DBIx::ScopedTransaction->new( $dbh );
	},
	'Create a transaction object in void context.',
);

lives_ok(
	sub
	{
		my $transaction = DBIx::ScopedTransaction->new( $dbh );
	},
	'Create a transaction object in scalar context.',
);

lives_ok(
	sub
	{
		my %data =
		(
			transaction => DBIx::ScopedTransaction->new( $dbh ),
		);
	},
	'Create a transaction object in list context.',
);
