package PostListHandler;

use strict;
use warnings;
# モジュール系
use lib '/usr/local/apache2/cgi-bin/module';
use BaseApp;
use Constants;
use LogHandler;
use Data::Dumper;
#####################################################
# 投稿ファイルの中身をヘッダ付きで返却
# @return:投稿ファイルの中身(配列)
#####################################################
sub get_all_post_list{
    LogHandler::output_info_log(Constants::LOG_MESSAGE_START_GET_ALL_POST_LIST);
    my @post_list_array;
    my $is_check;
    my $file_handler;# 投稿一覧ファイルのファイルハンドラ
    eval{
        #----------------------
        # ファイル読込
        #---------------------
        open($file_handler,"<", BaseApp::POST_LIST_FILE_PATH) or die(Constants::LOG_MESSAGE_ERR_NOT_FOUND_POST_LIST_FILE);
        my $line_index = 1;
        while(my $line = <$file_handler>){
            #----------------------
            # 改行コード及びダブルクォーテーションを削除し、配列に格納
            #----------------------
            chomp $line;
            $line =~ s/"//g;
            my @items = split(/,/,$line);
            #----------------------
            # 要素数チェック
            #----------------------
            $is_check = check_item_count($line_index,@items);
            unless($is_check){
                die();
            }
            push @post_list_array, \@items;
        $line_index++;
        };
    };
    #----------------------
    # 例外処理
    #----------------------
    if($@){
        chomp $@;
        my $error_message = $@;
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_GET_ALL_POST_LIST);
        return{
            result => Constants::FALSE,
            error_message => $error_message
        };
    };
    #----------------------
    # 行数チェック
    #----------------------
    $is_check = check_line_count(@post_list_array);
    unless($is_check){
        close($file_handler);
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_GET_ALL_POST_LIST);
        return{
            result => Constants::FALSE,
        };
    };
    close($file_handler);
    #----------------------
    # 終了処理
    #----------------------
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_GET_ALL_POST_LIST);
    return{
        result => Constants::TRUE,
        data => \@post_list_array
    };
}
#####################################################
# 投稿ファイルの一行当たりの要素数をチェック
# @param チェック対象の配列
# @return 成功（true）
# @return 失敗（false）
#####################################################
sub check_item_count{
    LogHandler::output_info_log(Constants::LOG_MESSAGE_START_CHECK_ITEM_COUNT);
    my($line_count,@line) = @_;
    my $is_check; # 判定フラグ
    my $item_count = @line; # 要素数
    #----------------------
    # 要素数チェック
    #----------------------
    unless($item_count == Constants::POST_LIST_ITEM_COUNT){
        $is_check = Constants::FALSE;
        LogHandler::output_error_log(Constants::LOG_MESSAGE_ERR_CHECK_ITEM_COUNT . "：" . "LINE ". $line_count);
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_CHECK_ITEM_COUNT);
        return $is_check;
    }
    $is_check = Constants::TRUE;
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_CHECK_ITEM_COUNT);
    return $is_check;
}
#####################################################
# 投稿ファイルの全体の行数をチェック
# @param チェック対象の配列
# @return 成功（true）
# @return 失敗（false）
#####################################################
sub check_line_count{
    LogHandler::output_info_log(Constants::LOG_MESSAGE_START_CHECK_LINE_COUNT);
    my(@all_line) = @_; # 対象ファイル
    my $is_check; # 判定フラグ
    my $all_line_count = @all_line; # 行数
    #----------------------
    # 行数チェック
    #----------------------
    if($all_line_count < Constants::POST_LIST_MIN_LINE){
        LogHandler::output_error_log(Constants::LOG_MESSAGE_ERR_CHECK_LINE_COUNT);
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_CHECK_LINE_COUNT);
        $is_check = Constants::FALSE;
        return $is_check;
    }
    $is_check = Constants::TRUE;
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_CHECK_LINE_COUNT);
    return $is_check;
}
#####################################################
# 新規投稿を登録
# @param 投稿ID
# @param 投稿内容
# @return 成功（true）
# @return 失敗（false）
#####################################################
sub register_new_post{
    LogHandler::output_info_log(Constants::LOG_MESSAGE_START_REGISTER_POST_LIST);
    (my $post_list_id,my $post_content) = @_;
    # 現在日時を取得
    my $current_datetime = BaseApp::get_current_datetime();
    #----------------------
    # 投稿ファイルを追記で書込
    #----------------------
    eval{
        my $file_handler; # 投稿一覧ファイルのファイルハンドラ
        open ($file_handler ,'>>' , BaseApp::POST_LIST_FILE_PATH) or die (Constants::LOG_MESSAGE_ERR_NOT_FOUND_POST_LIST_FILE);
        print $file_handler "\"$post_list_id\",\"$post_content\",\"$current_datetime\"\n";
        close($file_handler);
    };
    #----------------------
    # 例外処理
    #----------------------
    if($@){
        chomp $@;
        LogHandler::output_error_log(Constants::LOG_MESSAGE_ERR_NOT_FOUND_POST_LIST_FILE);
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_REGISTER_POST_LIST);
        return{
            result => Constants::FALSE,
            error_message => $@
        };
    };
    #----------------------
    # 終了処理
    #----------------------
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_REGISTER_POST_LIST);
    return{
        result => Constants::TRUE,
    };
}
#####################################################
# 投稿ID重複チェック
# @param post_id =  投稿ID
# @return result = 重複なし（true）
# @return result = 重複あり（false）
#####################################################
sub not_duplicate_post_id{
    my ($id_count_file_id) = @_;
    my $has_duplicate = Constants::FALSE; # 重複フラグ
    eval{
        my $file_handler;# 投稿一覧ファイルのファイルハンドラ
        #----------------------
        # ファイル読込
        #---------------------
        open($file_handler,"<", BaseApp::POST_LIST_FILE_PATH) or die(Constants::ERR_MSG_NOT_FOUND_POST_LIST_FILE);
        while(my $line = <$file_handler>){
            #----------------------
            # 改行コード及びダブルクォーテーションを削除し、配列に格納
            #----------------------
            chomp $line;
            $line =~ s/"//g;
            my @items = split(/,/,$line);
            if (@items <= 0) {
                next;
            };
            #----------------------
            # 投稿ID重複チェック
            #----------------------
            my $registered_id = $items[0];
            if($id_count_file_id eq $registered_id){
                $has_duplicate = Constants::TRUE;
                last;
            };
        };
    close($file_handler);
    };
    #----------------------
    # 投稿ID重複があったか判定
    #----------------------
    if($has_duplicate){
        return{
            result => Constants::FALSE,
            error_message => Constants::ERR_MSG_DUPLICATE_ID
        };
    };
    #----------------------
    # 例外処理
    #----------------------
    if($@){
        chomp $@;
        return{
            result => Constants::FALSE,
            error_message => $@
        };
    };
    #----------------------
    # 終了処理
    #----------------------
    return{
        result => Constants::TRUE,
    };
}

#####################################################
# 投稿削除処理
# @param post_id =  投稿ID
# @return result = 重複なし（true）
# @return result = 重複あり（false）
#####################################################
sub delete_post_list{
    LogHandler::output_info_log(Constants::LOG_MESSAGE_START_DELETE_POST_LIST);
    (my $delete_post_id) = @_;
    my @filtered;
    my @all_record;
    #======================
    # 全投稿を取得、削除対象のIDを含む行を除去した配列を作成し、書込処理
    #======================
    # 全投稿を取得
    my $get_all_post_list_result = get_all_post_list($delete_post_id);
    my $is_get_all_post_list = $get_all_post_list_result->{result};
    unless($is_get_all_post_list){
        my $error_message = $get_all_post_list_result->{error_message};
        return{
            result => Constants::FALSE,
            error_message => $error_message
        };
    }
    @all_record = @{$get_all_post_list_result->{data}};
    # 削除対象のIDを含む行を除去した配列を作成
    @filtered = grep { 
        my $one_record = $_;
        my $record_id = $one_record->[0];
        $record_id ne $delete_post_id;
    } @all_record;
    #----------------------
    # 書込処理
    #----------------------
    eval{
        my $file_handler;
        open ($file_handler,'>',BaseApp::POST_LIST_FILE_PATH) or die(Constants::LOG_MESSAGE_ERR_NOT_FOUND_POST_LIST_FILE);
        # 各行をCSV形式で書き込み
        print $file_handler map{
            "\"" . join(',',@$_) . "\"" . "\n"
        } @filtered;
        close($file_handler);
    };
    #----------------------
    # 例外処理
    #----------------------
    if($@){
        chomp $@;
        my $error_message = $@;
        LogHandler::output_error_log($error_message);
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_DELETE_POST_LIST);
        return{
            result => Constants::FALSE,
            error_message => $@
        };
    };
    #----------------------
    # 終了処理
    #----------------------
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_DELETE_POST_LIST);
    return{
        result => Constants::TRUE,
        data => \@filtered
    };
}
1; #perlモジュールは真値で終わる必要があるため































