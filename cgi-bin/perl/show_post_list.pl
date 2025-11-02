#!/usr/bin/perl

use strict;
use warnings;
# モジュール系
use lib '/usr/local/apache2/cgi-bin/module';
use lib '/usr/local/apache2/cgi-bin/validation';
use BaseApp;
use Constants;
use PostListHandler;
use PostListIdCountHandler;
use Data::Dumper;
use URI::Escape;
use CGI;
use new_post_validation;

#======================
# バリデーション
#======================