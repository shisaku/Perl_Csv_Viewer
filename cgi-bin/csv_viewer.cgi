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
use Encode qw(decode encode);
use Encode::Detect::Detector;

LogHandler::output_info_log(Constants::LOG_MESSAGE_START_OPEN_CSV_VIEWER);
#####################################################
# CSVデータの読み込み
#####################################################
my $csv_file = $cgi->param('csv_file');
my $filename = $cgi->upload('csv_file');



unless ($csv_file) {
    print_error();
    # exit;
}
binmode($filename);  # バイナリモード設定

my $csv = Text::CSV->new({ 
    binary => 1, 
    auto_diag => 1,
    sep_char => ',',      # カンマ区切り
    quote_char => '"',    # ダブルクォート
    escape_char => '"',   # エスケープ文字
    allow_whitespace => 1 # 空白を許可
});
my @rows;
# ======================================
# 読み込んだCSVをヘッダ部・データ部に分離し、HTML形式に変換
# ======================================
while (my $line = <$csv_file>) {
    my $detected_enc = Encode::Detect::Detector::detect($line) || 'UTF-8';
    $line = decode($detected_enc, $line);
    if ($csv->parse($line)) {
        my @fields = $csv->fields();
        push @rows, \@fields;
    }
}
my $header = $rows[0];
my @data = @rows[1..$#rows];
my $table_header = createHeaderElement($header);
my $table_data = createDataElement(\@data);
print "Content-Type: text/html; charset=UTF-8\n\n";
show_csv_viewer($filename,$table_header, $table_data);

LogHandler::output_info_log(Constants::LOG_MESSAGE_END_OPEN_CSV_VIEWER);
#####################################################
# 一覧画面を出力
#####################################################
sub parseCharacterEncoding{
    my ($targetArray,$characterEncoding) = @_;

}
#####################################################
# 一覧画面を出力
#####################################################
sub show_csv_viewer{
    my ($filename,$table_header, $table_data) = @_;
    print <<HTML;
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CSV VIEWER</title>
    <link rel="stylesheet" href="/css/csv_viewer.css">
    <script src="/js/csv_viewer.js"></script>
</head>
<body>
    <div class="header-container">
        <h1>$filename</h1>
        <button id="back-btn"class="back-button">BACK</button>
    </div>
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
    my $redirect_url = "/cgi-bin/system_error.cgi";

    print "Status: 302 Found\n";
    print "Location: $redirect_url\n";
    print "\n";
}