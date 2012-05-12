use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name          => 'DBIx::ScopedTransaction',
	license              => 'artistic',
	dist_author          => q{Guillaume Aubert <aubertg@cpan.org>},
	dist_version_from    => 'lib/DBIx/ScopedTransaction.pm',
	build_requires       =>
	{
		'Carp'                 => 0,
		'Data::Dumper'         => 0,
		'Data::Validate::Type' => 0,
		'DBD::SQLite'          => 0,
		'DBI'                  => 0,
		'File::Spec'           => 0,
		'Test::Exception'      => 0,
		'Test::More'           => 0,
		'Try::Tiny'            => 0,
	},
	requires             =>
	{
		'perl'                 => 5.006,
	},
	add_to_cleanup       =>
	[
		'DBIx-ScopedTransaction-*',
	],
	create_makefile_pl   => 'traditional',
	recursive_test_files => 1,
	configure_requires   =>
	{
		'Module::Build'        => 0,
	},
	meta_merge           =>
	{
		resources              =>
		{
			repository  => 'https://sourceforge.net/p/perltransaction/code',
			homepage    => 'https://metacpan.org/release/DBIx-ScopedTransaction',
			bugtracker  => 'http://rt.cpan.org/NoAuth/ReportBug.html?Queue=dbix-scopedtransaction',
		},
	},
);

$builder->create_build_script();
