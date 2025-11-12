#!/usr/bin/perl
use strict;
use warnings;
# モジュール系
use lib '/usr/local/apache2/cgi-bin/module';
use BaseApp;
use LogHandler;
use Constants;
use Data::Dumper;
use CGI;
use Text::CSV;
my $cgi = CGI->new();
use Encode 'decode';

LogHandler::output_info_log(Constants::LOG_MESSAGE_START_OPEN_CSV_VIEWER);
#####################################################
# CSVファイルのアップロードとCSVデータの読み込み
#####################################################
# ファイルアップロード処理
my $csv_file = $cgi->param('csv_file');
my $filename = $cgi->upload('csv_file');

print "Content-Type: text/html; charset=UTF-8\n\n";

unless ($csv_file) {
    print_error();
    exit;
}

# CSVデータを読み込む
my $csv = Text::CSV->new({ 
    binary => 1, 
    auto_diag => 1,
    sep_char => ',',      # カンマ区切り
    quote_char => '"',    # ダブルクォート
    escape_char => '"',   # エスケープ文字
    allow_whitespace => 1 # 空白を許可
});
my @rows;

while (my $line = <$csv_file>) {
    $line = decode('UTF-8', $line);
    if ($csv->parse($line)) {
        my @fields = $csv->fields();
        push @rows, \@fields;
    }
}

my $header = $rows[0];
my @data = @rows[1..$#rows];

my $table_header = createHeaderElement($header);
my $table_data = createDataElement(\@data);

show_csv_viewer($table_header, $table_data);

LogHandler::output_info_log(Constants::LOG_MESSAGE_END_OPEN_CSV_VIEWER);

#####################################################
# 一覧画面を出力
#####################################################
sub show_csv_viewer{
    my ($table_header, $table_data) = @_;
    print <<HTML;
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CSV ビューアー</title>
    <link rel="stylesheet" href="/css/csv_viewer.css">
</head>
<body>
    <h1>CSV ビューアー</h1>
    <table class="outer-border">
        <thead>
            <tr>
                $table_header
            </tr>
        </thead>
        <tbody>
            $table_data
        </tbody>
    </table>
</body>
</html>
HTML
}

#####################################################
# ヘッダ行の生成
# @param header ヘッダ行（配列リファレンス）
#####################################################
sub createHeaderElement{
    my ($header) = @_;
    my $table_header = "";
    foreach my $col (@$header) {
        $table_header .= "<th>$col</th>";
    }
    return $table_header;
}

#####################################################
# データ行の生成
# @param data データ行（配列リファレンス）
#####################################################
sub createDataElement{
    my ($data) = @_;
    my $table_data = "";
    foreach my $row (@$data) {
        $table_data .= "<tr>\n";
        foreach my $cell (@$row) {
            $table_data .= "<td>$cell</td>\n";
        }
        $table_data .= "</tr>\n";
    }
    return $table_data;
}

#####################################################
# エラー画面
#####################################################
sub print_error {
    LogHandler::output_info_log(Constants::LOG_MESSAGE_ERR_CSV_UPLOAD);
    my $message = "CSVファイルのアップロードに失敗しました。";
    print "<html><body><h1>エラー</h1><p>$message</p></body></html>\n";
}