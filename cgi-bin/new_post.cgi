#!/usr/bin/perl
use strict;
use warnings;
# モジュール系
use lib '/usr/local/apache2/cgi-bin/module';
use BaseApp;
use PostListHandler;
use LogHandler;
use Data::Dumper;
use CGI;
my $cgi = CGI->new();

#----------------------
# パラメータの受け取り
#----------------------
my $is_validate = $cgi->param('is_validate') ? $cgi->param('is_validate') : "";
my $validation_message = $cgi->param('validation_message') ? $cgi->param('validation_message') : "";
#----------------------
# 画面表示
#----------------------
LogHandler::output_info_log(Constants::LOG_MESSAGE_START_OPEN_NEW_POST);
show_initial_screen($is_validate,$validation_message);
LogHandler::output_info_log(Constants::LOG_MESSAGE_END_OPEN_NEW_POST);
#####################################################
# 新規投稿画面を表示
#####################################################
sub show_initial_screen {
    my ($is_validate,$validation_message) = @_;
    print "Content-Type: text/html; charset=UTF-8\n\n";
    #----------------------
    # エラー表示用HTMLの作成
    #----------------------
    my $error_html = "";
    unless($is_validate){
        $error_html = create_error_html($validation_message);
    }
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>投稿フォーム</title>
    <link rel="stylesheet" href="/css/new_post.css" type="text/css">
    <script src="/js/new_post.js"></script>
</head>
<body>
    <div class="form-container">
        <h1>新規投稿</h1>
        <form action="./perl/new_post.pl" method="post">
            <div class="form-group">
                <label for="post-content">投稿内容</label>
                $error_html
                <textarea id="post-content" name="post-content" placeholder="投稿内容を入力してください..." maxlength="100"></textarea>
            </div>
            
            <div class="button-group">
                <input type="submit" value="投稿する" class="btn btn-primary">
                <input type="button" id="back-button" value="戻る" class="btn btn-secondary">
            </div>
        </form>
    </div>
</body>
</html>
HTML
}
#####################################################
# エラーメッセージhtmlを描画
# @param エラーメッセージ
# @return エラーhtml
#####################################################
sub create_error_html{
    my ($validation_message) = @_;
    my $error_html = "";
    $error_html = qq{
    <span class="error-message">
        $validation_message
    </span>
    };
    return $error_html;
}