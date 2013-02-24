#!perl -T

use strict;
use warnings;

use DBI;
use DBIx::ScopedTransaction;
use File::Spec;
use Test::Exception;
use Test::More tests => 6;

use lib 't/lib';
use LocalTest;


my $dbh = LocalTest::ok_database_handle();

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
			sprintf(
				q|
					INSERT INTO test_commit( %s )
					VALUES( %s );
				|,
				$dbh->quote_identifier( 'name' ),
				$dbh->quote( 'test1' ),
			)
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

undef $dbh;
