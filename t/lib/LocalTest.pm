package LocalTest;

use strict;
use warnings;

use DBI;
use Test::More;


=head1 NAME

LocalTest - Test functions for L<DBIx::ScopedTransaction>.


=head1 VERSION

Version 1.1.1

=cut

our $VERSION = '1.1.1';


=head1 SYNOPSIS

	use lib 't/lib';
	use LocalTest;
	
	my $dbh = LocalTest::ok_database_handle();


=head1 FUNCTIONS

=head2 get_database_handle()

Create a database handle.

	my $dbh = LocalTest::get_database_handle();

=cut

sub get_database_handle
{
	$ENV{'SCOPED_TRANSACTION_DATABASE'} ||= 'dbi:SQLite::memory:||';
	
	my ( $database_dsn, $database_user, $database_password ) = split( /\|/, $ENV{'SCOPED_TRANSACTION_DATABASE'} );
	
	my $database_handle = DBI->connect(
		$database_dsn,
		$database_user,
		$database_password,
		{
			RaiseError => 1,
		}
	);
	
	return $database_handle
}


=head2 ok_database_handle()

Verify that a database handle can be created, and return it.

	my $dbh = LocalTest::ok_database_handle();

=cut

sub ok_database_handle
{
	ok(
		defined(
			my $database_handle = get_database_handle()
		),
		'Create connection to a database.',
	);
	
	my $database_type = $database_handle->{'Driver'}->{'Name'} || '';
	note( "Testing $database_type database." );
	
	return $database_handle;
}


=head1 AUTHOR

Guillaume Aubert, C<< <aubertg at cpan.org> >>.


=head1 BUGS

Please report any bugs or feature requests to C<bug-dbix-scopedtransaction at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DBIx-ScopedTransaction>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc LocalTest


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DBIx-ScopedTransaction>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DBIx-ScopedTransaction>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DBIx-ScopedTransaction>

=item * Search CPAN

L<http://search.cpan.org/dist/DBIx-ScopedTransaction>

=back


=head1 COPYRIGHT & LICENSE

Copyright 2009-2013 Guillaume Aubert.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License version 3 as published by the Free
Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see http://www.gnu.org/licenses/

=cut

1;
