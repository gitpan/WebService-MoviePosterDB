#!/usr/bin/perl
# $Id: movieposterdb.t 4600 2010-03-09 13:13:30Z chris $

use strict;
use warnings;

my @tests = (
    sub {
	use WebService::MoviePosterDB;

	my $w = new WebService::MoviePosterDB('api_version' => 1);
	my $m = $w->search('type' => "Movie", 'imdb_code' => 32904, 'width' => 300);

	die unless ($m);
	die unless ($m->imdbid() eq "tt0032904");
	die unless ($m->imdb() == 32904);
	die unless ($m->title() eq "The Philadelphia Story");
	die unless ($m->year() eq "1940");
	die unless ($m->page());
	die unless ($m->posters());
	die unless (scalar @{$m->posters()} > 0);
	foreach (@{$m->posters()}) { die unless $_->image_location(); }
    }, 

    sub {
	use WebService::MoviePosterDB;

	my $w = new WebService::MoviePosterDB('api_version' => 1);
	my $m = $w->search('type' => "Movie", 'imdbid' => "tt0032904", 'width' => 300);

	die unless ($m);
	die unless ($m->imdbid() eq "tt0032904");
	die unless ($m->imdb() == 32904);
	die unless ($m->title() eq "The Philadelphia Story");
	die unless ($m->year() eq "1940");
	die unless ($m->page());
	die unless ($m->posters());
	die unless (scalar @{$m->posters()} > 0);
	foreach (@{$m->posters()}) { die unless $_->image_location(); }
    }, 

    sub {
	use WebService::MoviePosterDB;
	
	my $w = new WebService::MoviePosterDB('api_version' => 1);
	my $m = $w->search('type' => "Movie", 'title' => "Goldfinger", 'width' => 300);

	die unless ($m);
	die unless ($m->imdbid() eq "tt0058150");
	die unless ($m->imdb() == 58150);
	die unless ($m->title() eq "Goldfinger");
	die unless ($m->year() eq "1964");
	die unless ($m->page());
	die unless ($m->posters());
	die unless (scalar @{$m->posters()} > 0);
	foreach (@{$m->posters()}) { die unless $_->image_location(); }
    },

    sub {
	use WebService::MoviePosterDB;
	
	my $w = new WebService::MoviePosterDB('api_version' => 1);
	my $m = $w->search('type' => "Movie", 'imdbid' => "tt0910970", 'width' => 300);

	die unless ($m);
	die unless ($m->imdbid() eq "tt0910970");
	die unless ($m->imdb() == 910970);
	die unless ($m->title() eq "WALL\x{b7}E");
	die unless ($m->year() eq "2008");
	die unless ($m->page());
	die unless ($m->posters());
	die unless (scalar @{$m->posters()} > 0);
	foreach (@{$m->posters()}) { die unless $_->image_location(); }
    },

#    sub {
#	use WebService::MoviePosterDB;
#	
#	my $w = new WebService::MoviePosterDB('api_version' => 1);
#	my $m = $w->search('type' => "Movie", 'title' => "WALL\x{b7}E", 'width' => 300);
#
#	die unless ($m);
#	die unless ($m->imdbid() eq "tt0032904");
#	die unless ($m->imdb() == 910970);
#	die unless ($m->title() eq "WALL\x{b7}E");
#	die unless ($m->year() eq "2008");
#	die unless ($m->page());
#	die unless ($m->posters());
#	die unless (scalar @{$m->posters()} > 0);
#	foreach (@{$m->posters()}) { die unless $_->image_location(); }
#    },

    );

if (defined $ENV{'MOVIEPOSTERDB_API_KEY'} && defined $ENV{'MOVIEPOSTERDB_API_SECRET'}) {
    push @tests, (
	sub {
	    use WebService::MoviePosterDB;

	    my $w = new WebService::MoviePosterDB('api_version' => 2, 'api_key' => $ENV{'MOVIEPOSTERDB_API_KEY'}, 'api_secret' => $ENV{'MOVIEPOSTERDB_API_SECRET'});
	    my $m = $w->search('type' => "Movie", 'imdbid' => "tt0032904", 'width' => 300);

	    die unless ($m);
	    die unless ($m->imdbid() eq "tt0032904");
	    die unless ($m->imdb() == 32904);
	    die unless ($m->title() eq "The Philadelphia Story");
	    die unless ($m->year() eq "1940");
	    die unless ($m->page());
	    die unless ($m->posters());
	    die unless (scalar @{$m->posters()} > 0);
	    foreach (@{$m->posters()}) { die unless $_->image_location(); }
	}, 

	sub {
	    use WebService::MoviePosterDB;
	
	    my $w = new WebService::MoviePosterDB('api_version' => 2, 'api_key' => $ENV{'MOVIEPOSTERDB_API_KEY'}, 'api_secret' => $ENV{'MOVIEPOSTERDB_API_SECRET'});
	    my $m = $w->search('type' => "Movie", 'title' => "Goldfinger", 'width' => 300);

	    die unless ($m);
	    die unless ($m->imdbid() eq "tt0058150");
	    die unless ($m->imdb() == 58150);
	    die unless ($m->title() eq "Goldfinger");
	    die unless ($m->year() eq "1964");
	    die unless ($m->page());
	    die unless ($m->posters());
	    die unless (scalar @{$m->posters()} > 0);
	    foreach (@{$m->posters()}) { die unless $_->image_location(); }
	},

	sub {
	    use WebService::MoviePosterDB;
	
	    my $w = new WebService::MoviePosterDB('api_version' => 2, 'api_key' => $ENV{'MOVIEPOSTERDB_API_KEY'}, 'api_secret' => $ENV{'MOVIEPOSTERDB_API_SECRET'});
	    my $m = $w->search('type' => "Movie", 'imdbid' => "tt0910970", 'width' => 300);

	    die unless ($m);
	    die unless ($m->imdbid() eq "tt0910970");
	    die unless ($m->imdb() == 910970);
	    die unless ($m->title() eq "WALL\x{b7}E");
	    die unless ($m->year() eq "2008");
	    die unless ($m->page());
	    die unless ($m->posters());
	    die unless (scalar @{$m->posters()} > 0);
	    foreach (@{$m->posters()}) { die unless $_->image_location(); }
	},

#	sub {
#	    use WebService::MoviePosterDB;
#	
#	    my $w = new WebService::MoviePosterDB('api_version' => 2, 'api_key' => $ENV{'MOVIEPOSTERDB_API_KEY'}, 'api_secret' => $ENV{'MOVIEPOSTERDB_API_SECRET'});
#	    my $m = $w->search('type' => "Movie", 'title' => "WALL\x{b7}E", 'width' => 300);
#
#	    die unless ($m);
#	    die unless ($m->imdbid() eq "tt0910970");
#	    die unless ($m->imdb() == 910970);
#	    die unless ($m->title() eq "WALL\x{b7}E");
#	    die unless ($m->year() eq "2008");
#	    die unless ($m->page());
#	    die unless ($m->posters());
#	    die unless (scalar @{$m->posters()} > 0);
#	    foreach (@{$m->posters()}) { die unless $_->image_location(); }
#	},

    );
}

printf "%d..%d\n", 1, scalar @tests;

foreach (@tests) {

    eval { &$_(); };

    if ($@) {
	print "not ok\n";
    } else {
	print "ok\n";
    }
}
