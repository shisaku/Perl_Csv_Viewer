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
my $cgi = CGI->new();
LogHandler::output_info_log(Constants::LOG_MESSAGE_START_REGISTER_POST);
# 投稿内容を受け取る
my $post_content = $cgi->param('post-content');
#----------------------
# 投稿IDの取得
#----------------------
my $get_result = PostListIdCountHandler::get_post_list_current_id();
my $is_get_result = $get_result->{result};
unless($is_get_result){
    # エラーとなったとき、リダイレクト→GETで再表示
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_REGISTER_POST);
    my $error_message = $get_result->{error_message};
    print "Status: 302 Found\n";
    print "Location: /cgi-bin/system_error.cgi\n\n";
    exit;
};
my $current_id = $get_result->{current_id};
my $next_id = $current_id + 1;
#======================
# バリデーション
#======================
my $validation_result = new_post_validation::validate($post_content,$next_id);
my $is_validate = $validation_result->{is_validate};
unless($is_validate){
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_REGISTER_POST);
    my $validation_message = $validation_result->{validation_message};
    # エラーとなったとき、リダイレクト→GETで再表示
    print "Status: 302 Found\n";
    print "Location: ../new_post.cgi?is_validate=" . uri_escape($is_validate) . "&validation_message=" . uri_escape($validation_message) . "\n\n";
    exit;
};
#======================
# 登録処理
#======================
#----------------------
# 投稿一覧の新規登録
#----------------------
my $register_result = PostListHandler::register_new_post($next_id,$post_content);
my $is_register_result = $register_result->{result};
unless($is_register_result){
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_REGISTER_POST);
    my $error_message = $register_result->{error_message};
    # エラーとなったとき、リダイレクト→GETで再表示
    print "Status: 302 Found\n";
    print "Location: /cgi-bin/system_error.cgi\n\n";
    exit;
};
#----------------------
# 投稿ID管理ファイルのカウントアップ
#----------------------
my $count_up_result = PostListIdCountHandler::count_up_post_list_id();
my $is_count_up_result = $count_up_result->{result};
unless($is_count_up_result){
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_REGISTER_POST);
    # エラーとなったとき、リダイレクト→GETで再表示
    my $error_message = $count_up_result->{error_message};
    print "Status: 302 Found\n";
    print "Location: /cgi-bin/system_error.cgi\n\n";
    exit;
};
#----------------------
# 完了処理
#----------------------
LogHandler::output_info_log(Constants::LOG_MESSAGE_END_REGISTER_POST);
print "Status: 302 Found\n";
print "Location: ../post_list.cgi" . "\n\n";
exit;