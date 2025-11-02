#!/usr/bin/perl
use strict;
use warnings;
# モジュール系
use lib '/usr/local/apache2/cgi-bin/module';
use BaseApp;
use PostListHandler;
use LogHandler;
use Constants;
use Data::Dumper;

show_input_csv_screen();
#####################################################
# CSV読み込み画面を表示
#####################################################
sub show_input_csv_screen{
    print "Content-Type: text/html; charset=UTF-8\n\n";
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <title>CSV読み込み</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/css/input_csv.css" type="text/css">
    <script src="/js/input_csv.js"></script>
</head>
<body>
    <div class="container">
        <h1>📊 CSV ビューアー</h1>
        
        <div class="upload-area" id="upload-area">
            <div class="upload-icon">📁</div>
            <div class="upload-text">CSVファイルをドラッグ&ドロップ</div>
            <div class="upload-subtext">または、クリックしてファイルを選択</div>
        </div>

        <input type="file" id="file-input" accept=".csv" />

        <div class="file-info" id="file-info">
            <div class="file-name" id="file-name"></div>
            <div id="file-size"></div>
        </div>

        <button class="load-button" id="load-button" disabled>CSVを読み込む</button>
    </div>
</body>
</html>
HTML
}