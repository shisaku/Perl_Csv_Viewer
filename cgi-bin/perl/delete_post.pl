#!/usr/bin/perl

use strict;
use warnings;
# モジュール系
use lib '/usr/local/apache2/cgi-bin/module';
use BaseApp;
use Constants;
use PostListHandler;
use LogHandler;
use CGI;
my $cgi = CGI->new();
use JSON::PP;
#####################################################
# 投稿削除処理
# @param post_id(json)
#####################################################
LogHandler::output_info_log(Constants::LOG_MESSAGE_START_DELETE_POST);
#----------------------
# POSTデータの取得とjson変換
#----------------------
my $post_data = $cgi->param('POSTDATA');
my $json_data;
eval {
    $json_data = decode_json($post_data) or die(Constants::LOG_MESSAGE_ERR_JSON_PARSE);
};
# エラーの時、500エラーを出力し、処理を終了
if ($@) {
    chomp $@;
    my $error_message = $@;
    LogHandler::output_error_log($error_message);
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_DELETE_POST);
    print $cgi->header(
        -type   => 'application/json',
        -status => '500 Internal Server Error'
    );
    print encode_json({
        status => "failed"
    });
    exit;
}
my $delete_post_id = $json_data->{deletePostId};
#----------------------
# 削除処理
#----------------------
my $delete_post_list_result = PostListHandler::delete_post_list($delete_post_id);
my $is_delete_post_list = $delete_post_list_result->{result};
# エラーの時、500エラーを出力し、処理を終了
unless($is_delete_post_list){
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_DELETE_POST);
    print $cgi->header(
    -type   => 'application/json',
    -status => '500 Internal Server Error'
    );
    print encode_json({
        status => "failed"
    });
    exit;
};
#----------------------
# 終了処理
#----------------------
my @data = $delete_post_list_result->{data};
print $cgi->header(
    -type   => 'application/json',
    -status => '200 OK'
);
print encode_json({
    status => "success",
    data => \@data,
    id => $delete_post_id
});
LogHandler::output_info_log(Constants::LOG_MESSAGE_END_DELETE_POST);
exit;