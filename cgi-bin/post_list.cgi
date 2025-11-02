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
#===================================================
# 投稿一覧ファイルを読み込み、一覧画面またばエラー画面を表示
#===================================================
LogHandler::output_info_log(Constants::LOG_MESSAGE_START_OPEN_POST_LIST);
my $post_list_read_result = PostListHandler::get_all_post_list();
if(!$post_list_read_result->{result}){
    # エラー画面を表示
    show_error_screen();
}else{
    # 一覧画面を表示
    show_initial_screen(@{$post_list_read_result->{data}});
};
LogHandler::output_info_log(Constants::LOG_MESSAGE_END_OPEN_POST_LIST);
#####################################################
# 一覧画面を表示
#####################################################
sub show_initial_screen {
    my (@post_list) = @_;
    print "Content-Type: text/html; charset=UTF-8\n\n";
    # テーブル形式の投稿一覧を取得
    my $post_list_table = create_post_list(@post_list);
    #======================
    # 一覧画面を出力
    #======================
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <title>掲示板</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/css/post_list.css" type="text/css">
    <script src="/js/post_list.js"></script>
</head>
<body>
    <h1>投稿一覧</h1>
    <form method="get" action="./new_post.cgi">
        <input type="submit" id="new-post-button" value="投稿画面へ">
    </form>
    $post_list_table
</body>
</html>
HTML
}
#####################################################
# エラー画面を表示
#####################################################
sub show_error_screen{
    print "Status: 302 Found\n";
    print "Location: /cgi-bin/system_error.cgi\n\n";
}

#####################################################
# 投稿一覧をテーブル形式にし、返却
# @param 投稿一覧
# @return テーブル形式の投稿一覧(String)
#####################################################
sub create_post_list{
    my (@post_list) = @_;
    my $post_list_table = "<table class='outer-border'>\n";
    my $line_count = 1;
    foreach my $line (@post_list){
        # ヘッダ
        # <tr>
        #     <th>$line->[1]</th>
        #     <th>$line->[2]</th>
        #     <th>削除</th>
        # </tr>
        if($line_count == 1){
            $post_list_table .= "<tr>\n\t<th>投稿内容</th>\n\t<th>投稿日時</th>\n\t<th>削除</th>\n</tr>\n"
        }else{
        # データ
        # <tr>
        #     <td><input type=\"hidden\" id=\"$line->[0]\">$line->[1]</td>
        #     <td>$line->[2]</td>
        #     <td><input type=\"button\" value=\"削除\"name=\"delete-button\"></td>
        # </tr>
            $post_list_table .= "<tr id=\"$line->[0]\">\n\t<td>$line->[1]</td>\n\t<td>$line->[2]</td>\n\t<td><input type=\"button\" value=\"削除\"name=\"delete-button\"></td>\n</tr>\n"
        }
        $line_count++;
    };
    $post_list_table .= "</table>\n";
    return $post_list_table;
}


























