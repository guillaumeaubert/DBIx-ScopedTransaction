#!perl -T

use strict;
use warnings;

use DBI;
use DBIx::ScopedTransaction;
use File::Spec;
use Test::Exception;
use Test::More tests => 8;


my $database_file = 'test_database_commit';

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

lives_ok
(
	sub
	{
		$dbh->do(
			q|
				CREATE TABLE test_commit(
					name VARCHAR(16)
				);
			|
		);
	},
	'Create test table.',
);

my $transaction = DBIx::ScopedTransaction->new( $dbh );

lives_ok
(
	sub
	{
		$dbh->do(
			q|
				INSERT INTO test_commit('name')
				VALUES('test1');
			|
		);
	},
	'Insert row.'
);

lives_ok
(
	sub
	{
		$transaction->commit() || die 'Failed to commit transaction';
	},
	'Commit transaction.',
);

my $rows_found;
lives_ok(
	sub
	{
		my $result = $dbh->selectrow_arrayref(
			q|
				SELECT COUNT(*)
				FROM test_commit
			|
		);
		
		$rows_found = $result->[0]
			if defined( $result ) && scalar( @$result ) != 0;
	},
	'Retrieve rows count.',
);

is(
	$rows_found,
	1,
	'Found 1 rows in the table, commit successful.',
);

# Destroy $dbh so that the underlying file stops being in use. Otherwise, we
# won't be able to unlink() on Windows.
undef $dbh;
ok(
	unlink( $database_file ),
	'Remove test database.'
);
