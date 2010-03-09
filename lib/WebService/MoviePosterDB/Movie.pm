# $Id: Movie.pm 4601 2010-03-09 13:15:53Z chris $

=head1 NAME

WebService::MoviePosterDB::Movie

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

package WebService::MoviePosterDB::Movie;

use strict;
use warnings;

our $VERSION = '0.13';

use Carp;
our @CARP_NOT = qw(WebService::MoviePosterDB);

use base qw(Class::Accessor);

__PACKAGE__->mk_accessors(qw(
    imdb
    title
    year
    page
    posters
));

use WebService::MoviePosterDB::Poster;

sub _new {
    my $class = shift;
    my $json = shift;
    my $self = {};

    if (defined $json->{'errors'}) { croak join("; ", map {s/\.*$//; $_} @{$json->{'errors'}}); }

    bless $self, $class;

    $self->imdb($json->{'imdb'});
    $self->title($json->{'title'});
    $self->year($json->{'year'});
    $self->page($json->{'page'});
    if (defined $json->{'imageurl'}) {
	# Fudged for the response from legacy API
	$self->posters([WebService::MoviePosterDB::Poster->_new( {'image_location' => $json->{'imageurl'}} )]);
    } else {
	my @posters;
	foreach ( @{$json->{'posters'}} ) {
	    push @posters, WebService::MoviePosterDB::Poster->_new($_);
	}
	$self->posters(\@posters);
    }

    return $self;
}

=head1 METHODS

=head2 imdbid()

=cut

sub imdbid {
    my $self = shift;
    return sprintf("tt%07d", $self->imdb());
}

=head2 imdb()

=head2 title()

=head2 year()

=head2 page()

=head2 posters()

=cut

1;
