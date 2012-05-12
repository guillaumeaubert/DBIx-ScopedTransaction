#!perl -T

use strict;
use warnings;

use DBI;
use DBIx::ScopedTransaction;
use File::Spec;
use Test::Exception;
use Test::More tests => 7;


my $database_file = 'test_database_new';

SKIP:
{
	skip(
		'Database ready to be set up.',
		1,
	) if !-e $database_file;
	
	ok(
		unlink( $database_file ),
		'Remove old test database.'
	);
}

ok(
	my $dbh = DBI->connect(
		"dbi:SQLite:dbname=$database_file",
		'',
		'',
		{
			RaiseError => 1,
		}
	),
	'Create connection to a SQLite database.',
);

my $transaction;
lives_ok(
	sub
	{
		$transaction = DBIx::ScopedTransaction->new( $dbh );
	},
	'Create a transaction object.',
);

isa_ok(
	$transaction,
	'DBIx::ScopedTransaction',
	'Transaction object'
);

lives_ok
(
	sub
	{
		open( STDERR, '>', File::Spec->devnull() ) || die "could not open STDERR: $!";
	},
	'Redirect STDERR to destroy transaction object silently.',
);

lives_ok(
	sub
	{
		undef $transaction;
	},
	'Destroy transaction object.',
);

ok(
	unlink( $database_file ),
	'Remove test database.'
);