#!/usr/bin/env perl
#
# Weather forecast for Conky
#
# Copyright (C) 2011 Xiaodong Xu <xxdlhy@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

use Modern::Perl;
use HTTP::Tiny;
use XML::Twig;

my $http = HTTP::Tiny->new(
    agent => 'Mozilla/5.0 (X11; Linux i686)
    AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.1 Safari/534.24',
);
my $url = 'http://www.google.com/ig/api?weather=Nanchong';
my $xml = $http->get($url)->{content};

my $twig = XML::Twig->new;
$twig->parse($xml);

my $condition = $twig->first_elt('condition')->att('data');
my $temp      = $twig->first_elt('temp_c')->att('data');

say "$temp° $condition";
