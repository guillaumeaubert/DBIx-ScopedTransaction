#!perl -T

use strict;
use warnings;

use DBI;
use DBIx::ScopedTransaction;
use Test::Exception;
use Test::More tests => 11;


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
		$dbh->do(
			q|
				CREATE TABLE test_out_of_scope(
					name VARCHAR(16)
				);
			|
		);
	},
	'Create test table.',
);

my $destroy_logs = [];
ok(
	local $DBIx::ScopedTransaction::DESTROY_LOGGER = sub
	{
		my ( $messages ) = @_;
		push( @$destroy_logs, @$messages );
	},
	'Set up capture of messages from DBIx::ScopedTransaction::DESTROY.',
);

{
	my $transaction;
	lives_ok(
		sub
		{
			$transaction = DBIx::ScopedTransaction->new( $dbh );
		},
		'Create a transaction object.',
	);
	
	lives_ok
	(
		sub
		{
			$dbh->do(
				q|
					INSERT INTO test_out_of_scope('name')
					VALUES('test1');
				|
			);
		},
		'Insert row.'
	);
}
note('Transaction object should have gone out of scope now.');

isnt(
	scalar( @$destroy_logs ),
	0,
	'Detected issues when transaction object was destroyed.',
) || diag( explain( $destroy_logs ) );

is(
	scalar ( grep { $_ eq 'Transaction object created at t/40-DESTROY.t:54 is going out of scope, but the transaction has not been committed or rolled back; check logic.' } @$destroy_logs ),
	1,
	'Found warning explaining where the transaction was started and that is was not completed properly.',
) || diag( explain( $destroy_logs ) );

is(
	scalar( grep { $_ eq 'Forced rolling back the transaction to prevent issues.' } @$destroy_logs ),
	1,
	'Forced rolled back in DESTROY() successfully.',
) || diag( explain( $destroy_logs ) );

is(
	scalar( @$destroy_logs ),
	2,
	'No unexpected issues reported.',
) || diag( explain( $destroy_logs ) );

my $rows_found;
lives_ok(
	sub
	{
		my $result = $dbh->selectrow_arrayref(
			q|
				SELECT COUNT(*)
				FROM test_out_of_scope
			|
		);
		
		$rows_found = $result->[0]
			if defined( $result ) && scalar( @$result ) != 0;
	},
	'Retrieve rows count.',
);

is(
	$rows_found,
	0,
	'Found 0 rows in the table, auto-rollback successful.',
);
