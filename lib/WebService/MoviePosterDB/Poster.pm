# $Id: Poster.pm 4601 2010-03-09 13:15:53Z chris $

=head1 NAME

WebService::MoviePosterDB::Poster

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

package WebService::MoviePosterDB::Poster;

use strict;
use warnings;

our $VERSION = '0.13';

use base qw(Class::Accessor);

__PACKAGE__->mk_accessors(qw(
    image_location
));

sub _new {
    my $class = shift;
    my $json = shift;
    my $self = {};

    bless $self, $class;

    $self->image_location($json->{'image_location'});

    return $self;
}

=head1 METHODS

=head2 image_location()

=cut

1;
