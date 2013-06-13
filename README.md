DBIx-ScopedTransaction
======================

[![Build Status](https://travis-ci.org/guillaumeaubert/DBIx-ScopedTransaction.png?branch=master)](https://travis-ci.org/guillaumeaubert/DBIx-ScopedTransaction)
[![Coverage Status](https://coveralls.io/repos/guillaumeaubert/DBIx-ScopedTransaction/badge.png?branch=master)](https://coveralls.io/r/guillaumeaubert/DBIx-ScopedTransaction?branch=master)

DBIx::ScopedTransaction is a module that allows scoping database transactions
on DBI handles in code, to detect and prevent issues with unterminated
transactions.


INSTALLATION
------------

To install this module, run the following commands:

	perl Build.PL
	./Build
	./Build test
	./Build install


SUPPORT AND DOCUMENTATION
-------------------------

After installing, you can find documentation for this module with the
perldoc command.

	perldoc DBIx::ScopedTransaction


You can also look for information at:

 * [GitHub's request tracker (report bugs here)]
   (https://github.com/guillaumeaubert/DBIx-ScopedTransaction/issues)

 * [AnnoCPAN, Annotated CPAN documentation]
   (http://annocpan.org/dist/DBIx-ScopedTransaction)

 * [CPAN Ratings]
   (http://cpanratings.perl.org/d/DBIx-ScopedTransaction)

 * [MetaCPAN]
   (https://metacpan.org/release/DBIx-ScopedTransaction)


LICENSE AND COPYRIGHT
---------------------

Copyright (C) 2012-2013 Guillaume Aubert

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License version 3 as published by the Free
Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see http://www.gnu.org/licenses/

