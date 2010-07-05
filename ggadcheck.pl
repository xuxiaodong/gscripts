#!/usr/bin/env perl
#
# Check Google Adsense revenue
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

use 5.012;
use warnings;

use LWP::UserAgent;
use HTTP::Cookies;

my $username = '';
my $password = '';

my $ua = LWP::UserAgent->new( cookie_jar => HTTP::Cookies->new() );

my $google_account = $ua->get(
    'https://www.google.com/accounts/ServiceLoginBoxAuth',
    {   continue => 'https://www.google.com/adsense/login-box-gaiaauth',
        foolowup => 'https://www.google.com/adsense/login-box-gaiaauth',
        service  => 'adsense',
        ltmpl    => 'login',
        rm       => 'false',
        Email    => $username,
        Passwd   => $password,
        null     => 'Login'
    }
);

my ($galx) =
    $google_account->as_string =~ m{name="GALX"\s+value="([^"]+)">}msg;

my $google_adsense = $ua->post(
    'https://www.google.com/accounts/ServiceLoginBoxAuth',
    {   continue => 'https://www.google.com/adsense/login-box-gaiaauth',
        foolowup => 'https://www.google.com/adsense/login-box-gaiaauth',
        service  => 'adsense',
        ltmpl    => 'login',
        rm       => 'false',
        Email    => $username,
        Passwd   => $password,
        GALX     => $galx,
        null     => 'Login'
    }
);

if ( $google_adsense->as_string =~ /CheckCookie/ ) {
    $google_adsense = $ua->get(
        'https://www.google.com/accounts/CheckCookie?continue=https://www.google.com/adsense/login-box-gaiaauth&service=adsense&ltmpl=login&chtml=LoginDoneHtml'
    );
    if ( $google_adsense->as_string =~ /SetSID/ ) {
        my ($uri) =
            $google_adsense->as_string =~ /Refresh:\s+\d+;\s*url\='([^']+)'/;

        $google_adsense = $ua->get($uri);
    }
}

my $balance = quotemeta('今日估算收入');
my $income;
if ( $google_adsense->as_string =~ /$balance.*?(\d+\.\d+)/s ) {
    $income = $1;
}

my $google_adsense_thismonth = $ua->get(
    'https://www.google.com/adsense/report/overview?timePeriod=thismonth');

my $balance_thismonth = quotemeta('估算总收入');
my $income_thismonth;
if ( $google_adsense_thismonth->as_string
    =~ /$balance_thismonth.*?(\d+\.\d+)/s )
{
    $income_thismonth = $1;
}

my $google_adsense_sincelastpayment = $ua->get(
    'https://www.google.com/adsense/report/overview?timePeriod=sincelastpayment'
);

my $balance_sincelastpayment = quotemeta('估算总收入');
my $income_sincelastpayment;
if ( $google_adsense_sincelastpayment->as_string
    =~ /$balance_sincelastpayment.*?(\d+\.\d+)/s )
{
    $income_sincelastpayment = $1;
}

say "$income/$income_thismonth/$income_sincelastpayment";
