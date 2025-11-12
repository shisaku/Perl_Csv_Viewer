#!/usr/bin/perl
use strict;
use warnings;
# モジュール系
use lib '/usr/local/apache2/cgi-bin/module';
use BaseApp;
use LogHandler;
use Constants;
use Data::Dumper;

LogHandler::output_info_log(Constants::LOG_MESSAGE_START_OPEN_SYSTEM_ERROR);
show_error_screen();
LogHandler::output_info_log(Constants::LOG_MESSAGE_END_OPEN_SYSTEM_ERROR);
#####################################################
# エラー画面を表示
# @param エラーメッセージ
#####################################################
sub show_error_screen {
    print "Content-Type: text/html; charset=UTF-8\n\n";
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>システムエラー</title>
    <link rel="stylesheet" href="/css/system_error.css" type="text/css">
    <script src="/js/system_error.js"></script>
</head>
<body>
    <div class="error-container">
        <h1>システムエラー</h1>
        <p class="error-message">サイト管理者までご連絡ください</p>
        <div class="buttons">
            <button id="back-button">戻る</button>
        </div>
    </div>
</body>
</html>
HTML
}