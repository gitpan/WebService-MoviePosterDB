#!/usr/bin/perl
# $Id: Makefile.PL 3566 2010-01-03 20:54:05Z chris $

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'WebService::MoviePosterDB',
    VERSION_FROM    => 'lib/WebService/MoviePosterDB.pm'
    );
