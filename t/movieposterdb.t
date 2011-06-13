#!/usr/bin/perl
# $Id: movieposterdb.t 6476 2011-06-13 01:15:32Z chris $

use strict;
use warnings;

use Test::More;

BEGIN { use_ok('WebService::MoviePosterDB'); }

{
    my ($W, $D);

    local $SIG{__WARN__} = sub { $W = shift; };
    local $SIG{__DIE__}  = sub { $D = shift; };

    $W = ""; $D = "";
    WebService::MoviePosterDB->new();
    like($W, qr/^version 1 API is no longer available, using demo credentials/);
    is($D, "");

    $W = ""; $D = "";
    WebService::MoviePosterDB->new('api_version' => 1);
    like($W, qr/^version 1 API is no longer available, using demo credentials/);
    is($D, "");

    $W = ""; $D = "";
    eval { WebService::MoviePosterDB->new('api_version' => 2); };
    is($W, "");
    like($D, qr/^api_key and\/or api_secret missing/);

    $W = ""; $D = "";
    eval { WebService::MoviePosterDB->new('api_key' => "key"); };
    is($W, "");
    like($D, qr/^api_key and\/or api_secret missing/);

}

my @ws;

push @ws, new_ok('WebService::MoviePosterDB', ['api_key' => "demo", 'api_secret' => "demo"]);
if (defined $ENV{'MOVIEPOSTERDB_API_KEY'} && defined $ENV{'MOVIEPOSTERDB_API_SECRET'}) {
    push @ws, new_ok('WebService::MoviePosterDB', ['api_version' => 2, 'api_key' => $ENV{'MOVIEPOSTERDB_API_KEY'}, 'api_secret' => $ENV{'MOVIEPOSTERDB_API_SECRET'}]);
}

my $page_regexp = qr|^http://www\.movieposterdb\.com/movie/\d+/.*\.html$|;
my $il_regexp = qr|^http://api\.movieposterdb\.com/cache/normal/\d+/\d+/\d+_\d+.jpg|;

foreach (@ws) {

    {
	my $m = $_->search('type' => "Movie", 'tconst' => "tt0032904", 'width' => 300);

	ok($m, '$m');
	is($m->tconst(), "tt0032904", '$m->tconst()');
	is($m->imdbid(), "tt0032904", '$m->imdbid()');
	cmp_ok($m->imdb(), "==", 32904, '$m->imdb()');
	is($m->title(), "The Philadelphia Story", '$m->title()');
	is($m->year(), "1940", '$m->year()');
	like($m->page(), $page_regexp, '$m->page()');
	isa_ok($m->posters(), "ARRAY", '$m->posters()');
	cmp_ok(scalar @{$m->posters()}, ">", 0, '@{$m->posters()} > 0');
	foreach (@{$m->posters()}) { like($_->image_location(), $il_regexp, '$m->posters()->[]->image_location()'); }
    }

    {
	my $m = $_->search('type' => "Movie", 'imdbid' => "tt0032904", 'width' => 300);

	ok($m, '$m');
	is($m->tconst(), "tt0032904", '$m->tconst()');
	is($m->imdbid(), "tt0032904", '$m->imdbid()');
	cmp_ok($m->imdb(), "==", 32904, '$m->imdb()');
	is($m->title(), "The Philadelphia Story", '$m->title()');
	is($m->year(), "1940", '$m->year()');
	like($m->page(), $page_regexp, '$m->page()');
	isa_ok($m->posters(), "ARRAY", '$m->posters()');
	cmp_ok(scalar @{$m->posters()}, ">", 0, '@{$m->posters()} > 0');
	foreach (@{$m->posters()}) { like($_->image_location(), $il_regexp, '$m->posters()->[]->image_location()'); }
    }

    {
	my $m = $_->search('type' => "Movie", 'imdb_code' => 32904, 'width' => 300);

	ok($m, '$m');
	is($m->tconst(), "tt0032904", '$m->tconst()');
	is($m->imdbid(), "tt0032904", '$m->imdbid()');
	cmp_ok($m->imdb(), "==", 32904, '$m->imdb()');
	is($m->title(), "The Philadelphia Story", '$m->title()');
	is($m->year(), "1940", '$m->year()');
	like($m->page(), $page_regexp, '$m->page()');
	isa_ok($m->posters(), "ARRAY", '$m->posters()');
	cmp_ok(scalar @{$m->posters()}, ">", 0, '@{$m->posters()} > 0');
	foreach (@{$m->posters()}) { like($_->image_location(), $il_regexp, '$m->posters()->[]->image_location()'); }
    }

    {
	my $m = $_->search('type' => "Movie", 'title' => "Goldfinger", 'width' => 300);

	ok($m, '$m');
	is($m->tconst(), "tt0058150", '$m->tconst()');
	is($m->imdbid(), "tt0058150", '$m->imdbid()');
	cmp_ok($m->imdb(), "==", 58150, '$m->imdb()');
	is($m->title(), "Goldfinger", '$m->title()');
	is($m->year(), "1964", '$m->year()');
	like($m->page(), $page_regexp, '$m->page()');
	isa_ok($m->posters(), "ARRAY", '$m->posters()');
	cmp_ok(scalar @{$m->posters()}, ">", 0, '@{$m->posters()} > 0');
	foreach (@{$m->posters()}) { like($_->image_location(), $il_regexp, '$m->posters()->[]->image_location()'); }
    }

    {
	my $m = $_->search('type' => "Movie", 'imdbid' => "tt0910970", 'width' => 300);

	ok($m, '$m');
	is($m->tconst(), "tt0910970", '$m->tconst()');
	is($m->imdbid(), "tt0910970", '$m->imdbid()');
	cmp_ok($m->imdb(), "==", 910970, '$m->imdb()');
	is($m->title(), "WALL\x{b7}E", '$m->title()');
	is($m->year(), "2008", '$m->year()');
	like($m->page(), $page_regexp, '$m->page()');
	isa_ok($m->posters(), "ARRAY", '$m->posters()');
	cmp_ok(scalar @{$m->posters()}, ">", 0, '@{$m->posters()} > 0');
	foreach (@{$m->posters()}) { like($_->image_location(), $il_regexp, '$m->posters()->[]->image_location()'); }
    }

    if (0) {
	my $m = $_->search('type' => "Movie", 'title' => "WALL\x{b7}E", 'width' => 300);

	ok($m, '$m');
	is($m->tconst(), "tt0032904", '$m->tconst()');
	is($m->imdbid(), "tt0032904", '$m->imdbid()');
	cmp_ok($m->imdb(), "==", 910970, '$m->imdb()');
	is($m->title(), "WALL\x{b7}E", '$m->title()');
	is($m->year(), "2008", '$m->year()');
	like($m->page(), $page_regexp, '$m->page()');
	isa_ok($m->posters(), "ARRAY", '$m->posters()');
	cmp_ok(scalar @{$m->posters()}, ">", 0, '@{$m->posters()} > 0');
	foreach (@{$m->posters()}) { like($_->image_location(), $il_regexp, '$m->posters()->[]->image_location()'); }
    }
}

done_testing();
