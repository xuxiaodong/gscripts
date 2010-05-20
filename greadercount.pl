#!/usr/bin/env perl
#
# Google Reader unread count for Conky
#
# Copyright (C) 2010 Xiaodong Xu <xxdlhy@gmail.com>
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

use strict;
use warnings;

use WebService::Google::Reader;

my $user = '';
my $pass = '';

my $gr = WebService::Google::Reader->new(
    username => $user,
    password => $pass,
);

my $counts = $gr->unread( count => 1000 )->entries || 0;

print "$counts";
