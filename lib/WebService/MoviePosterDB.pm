# $Id: MoviePosterDB.pm 3771 2010-01-20 11:11:24Z chris $

=head1 NAME

WebService::MoviePosterDB - OO Perl interface to the movie poster database MoviePosterDB.

=head1 SYNOPSIS

    use WebService::MoviePosterDB;

    my $ws = WebService::MoviePosterDB->new(cache => 1, cache_exp => "12h");

    my $movie = $ws->search(type => "Movie", imdbid => "tt0114814", width => 300);

    print $movie->title(), ": \n\n";
    print $movie->page(), "\n\n";

    foreach ( @{$movie->posters()} ) {
        print $_->image_location(), "\n";
    }

=head1 DESCRIPTION

WebService::MusicBrainz is an object-oriented interface to MoviePosterDB.  It can 
be used to retrieve artwork for IMDB titles.

=cut

package WebService::MoviePosterDB;

use strict;
use warnings;

our $VERSION = '0.12';

use Cache::FileCache;

use Carp;

use Digest::MD5 qw(md5_hex);

use File::Spec::Functions qw(tmpdir);

use JSON;
use LWP::UserAgent;
use URI;

use WebService::MoviePosterDB::Movie;

=head1 METHODS

=head2 new(%opts)

Constructor.

%opts can contain:

=over 4

=item api_version - Which API to use.

=over 4

1 - http://api.movieposterdb.com/json.inc.php

2 - http://api.movieposterdb.com/json

=back

Defaults to 1, unless an api_key is supplied in which case, defaults to 2

=item api_key, api_secret

A key and secret are required if using the version 2 API.  Contact movieposterdb.com for details.

=item cache

Whether to cache responses.  Defaults to true

=item cache_root 

The root dir for the cache.  Defaults to tmpdir();

=item cache_exp 

How long to cache responses for.  Defaults to "1h"

=back

=cut

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {};
    
    bless $self, $class;
    
    $self->{'api_key'} = $args{'api_key'} || "demo";
    $self->{'api_secret'} = $args{'api_secret'} || "demo";
    $self->{'api_version'} = $args{'api_version'} || (defined $args{'api_key'} ? 2 : 1);

    $self->{'_cache_root'} = $args{'cache_root'} || tmpdir();
    $self->{'_cache_exp'} = $args{'cache_exp'} || "1h";
    $self->{'_cache'} = defined $args{'cache'} ? $args{'cache'} : 1;

    if ($self->{'_cache'}) {
	$self->{'_cacheObj'} = Cache::FileCache->new( {'cache_root' => $self->{'_cache_root'}, 'namespace' => "WebService-MoviePosterDB", 'default_expires_in' => $self->{'_cache_exp'}} );
    }

    $self->{'_useragent'} = LWP::UserAgent->new();
    $self->{'_useragent'}->env_proxy();
    $self->{'_useragent'}->agent("WebService::MoviePosterDB/$VERSION");

    return $self;
}


=head2 search(type => "Movie", %args)

Accesses MoviePosterDB and returns a WebService::MoviePosterDB::Movie object.

%args can contain:

=over 4

=item type

Controls the type of resource being requested.  Currently only supports "Movie".

=item imdbid

IMDB id for the title, e.g. tt0114814

=item title

Name of the title

=item width

Image width for returned artwork

=back

=cut

sub search {
    my $self = shift;
    my %args = @_;

    croak "Unknown type" unless ($args{'type'} eq "Movie");
    if (defined $args{'imdbid'}) {
	($args{'imdb_code'}) = $args{'imdbid'} =~ m/^tt(\d{6,7})$/ or croak "Unable to parse imdbid '$args{'imdbid'}'";
	$args{'imdb_code'} += 0;
	delete $args{'imdbid'};
    }

    my $legacy = $self->{'api_version'} == 1;

    my %_args;

    if (!$legacy) {
	$_args{'api_key'} = $self->{'api_key'};
	$_args{'secret'} = $self->_get_secret($args{'imdb_code'}, $args{'title'});
    }
    
    foreach (keys %args) {
	my ($k, $v) = ($_, $args{$_});
	    
	# Fixup to make json.inc.php look like json
	if ($k eq "imdb_code") {
	    if ($legacy) { $k = "imdb"; }
	    $v = sprintf("%d", $v); # Remove any leading zeroes
	} elsif ($k eq "title") {
	    # Nothing
	} elsif ($k eq "width") {
	    # Nothing
	} else {
	    next;
	}

	$_args{$k} = $v;

    }

    my $uri = URI->new();
    $uri->scheme("http");
    $uri->host("api.movieposterdb.com");
    $uri->path($legacy ? "json.inc.php": "json");
    my @_args = map {$_, $_args{$_}} sort keys %_args;
    foreach (@_args) { utf8::encode($_); }
    $uri->query_form(@_args);

    my $json = JSON->new()->decode($self->_get_page($uri->as_string()));

    return WebService::MoviePosterDB::Movie->_new($json);

}

sub _get_secret {
    my $self = shift;
    my $imdb_code = shift;
    my $title = shift;

    my $v = $self->{'api_secret'};
    if (defined($imdb_code)) { $v .= sprintf("%d", $imdb_code); }
    if (defined($title)) { $v .= $title; }

    utf8::encode($v);

    return substr(md5_hex($v), 10, 12);

}

sub _get_page {
    my $self = shift;
    my $url = shift;

    my $content;

    if ($self->{'_cache'}) {
	$content = $self->{'_cacheObj'}->get($url);
    }

    if (! defined $content) {
	my $response = $self->{'_useragent'}->get($url);
    
	if($response->code() ne "200") {
	    croak "URL (", $url, ") Request Failed - Code: ", $response->code(), " Error: ", $response->message(), "\n";
	}

	$content = $response->decoded_content();

	if ($self->{'_cache'}) {
	    $self->{'_cacheObj'}->set($url, $content);
	}
    }

    return $content;
}

1;
