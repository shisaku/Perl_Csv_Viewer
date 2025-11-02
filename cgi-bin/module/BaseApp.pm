package BaseApp;

use strict;
use warnings;
# モジュール系
use Time::Piece;
#####################################################
# configファイルの読込と定数定義
#####################################################
#----------------------
# configファイルの読込
#----------------------
my $config_obj;
# コンパイル時に実行
BEGIN{
    my $CONFIG_FILE_PATH="/usr/local/apache2/cgi-bin/config/config.pl";
    $config_obj = do $CONFIG_FILE_PATH or die "$!$@"; # TODO:例外処理
};
#----------------------
# 定数定義
#----------------------
# コンパイル時に実行
use constant{
    # 投稿一覧のCSVファイルパス
    POST_LIST_FILE_PATH => $config_obj->{FILE_PATH}->{post_list_csv},
    # 投稿一覧のIDカウント管理ファイルパス
    POST_LIST_ID_COUNT_FILE_PATH => $config_obj->{FILE_PATH}->{post_list_id_count_file_path},
    # logフォルダパス
    LOG_FOLDER_PATH => $config_obj->{FILE_PATH}->{log_folder_path}
};
#####################################################
# 現在日時を取得
# return 現在日時（yyyy/mm/dd hh:mm:ss）
#####################################################
sub get_current_datetime{
    $ENV{TZ} = 'Asia/Tokyo';
    my $t = localtime();
    my $current_datetime = $t->strftime("%Y/%m/%d %H:%M:%S");
    return $current_datetime;

};
#####################################################
# 現在日付を取得
# return 現在日時（yyyy/mm/dd hh:mm:ss）
#####################################################
sub get_current_date{
    $ENV{TZ} = 'Asia/Tokyo';
    my $t = localtime();
    my $current_date = $t->strftime("%Y-%m-%d");
    return $current_date;

}
1; #perlモジュールは真値で終わる必要があるため