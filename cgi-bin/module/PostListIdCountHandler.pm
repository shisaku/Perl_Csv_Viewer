package PostListIdCountHandler;

use strict;
use warnings;
# モジュール系
use lib '/usr/local/apache2/cgi-bin/module';
use BaseApp;
use Constants;
use LogHandler;
use Data::Dumper;

#####################################################
# 現在の投稿一覧のIDを取得
# @return result = 成功（true）, current_id = 現在の投稿ID
# @return result = 失敗（false）, error_message = エラーメッセージ
#####################################################
sub get_post_list_current_id{
    LogHandler::output_info_log(Constants::LOG_MESSAGE_START_GET_CURRENT_ID);
    my $current_id;
    eval{
        #----------------------
        # ファイル読込
        #---------------------
        my $file_obj = do BaseApp::POST_LIST_ID_COUNT_FILE_PATH or die Constants::LOG_MESSAGE_ERR_NOT_FOUND_POST_LIST_ID_COUNT_FILE;
        $current_id = $file_obj->{COUNT}->{ID};
    };
    #----------------------
    # 例外処理
    #----------------------
    if($@){
        chomp $@;
        my $error_message = $@;
        LogHandler::output_error_log($error_message);
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_GET_CURRENT_ID);
        return{
            result => Constants::FALSE,
            error_message => $@
        };
    };
    #----------------------
    # 終了処理
    #----------------------
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_GET_CURRENT_ID);
    return{
        result => Constants::TRUE,
        current_id => $current_id
    };
};
#####################################################
# 投稿IDをカウントアップ
# @return result = 成功（true）, current_id = 現在の投稿ID
# @return result = 失敗（false）, error_message = エラーメッセージ
#####################################################
sub count_up_post_list_id{
    LogHandler::output_info_log(Constants::LOG_MESSAGE_START_COUNTUP_POST_ID);
    #----------------------
    # 現在の投稿IDを取得
    #---------------------
    my $get_result = get_post_list_current_id();
    my $is_get_result = $get_result->{result};
    unless($is_get_result){
        my $error_message = $get_result->{error_message};
        return{
            result => Constants::FALSE,
            error_message => $error_message
        };
    };
    eval{
        my $current_id = $get_result->{current_id};
        my $next_id = $current_id + 1; 
        my $file_handler; 
        open ($file_handler,'>', BaseApp::POST_LIST_ID_COUNT_FILE_PATH) or die(Constants::LOG_MESSAGE_ERR_NOT_FOUND_POST_LIST_ID_COUNT_FILE);
        my $post_id_count_file_content = <<FILE_CONTENT;
{
    COUNT => {
        ID => $next_id,
    }
}
FILE_CONTENT
        print $file_handler $post_id_count_file_content;
    };
    #----------------------
    # 例外処理
    #----------------------
    if($@){
        chomp $@;
        my $error_message = $@; 
        LogHandler::output_error_log($error_message);
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_COUNTUP_POST_ID);
        return{
            result => Constants::FALSE,
            error_message => $@
        };
    };
    #----------------------
    # 終了処理
    #----------------------
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_COUNTUP_POST_ID);
    return{
        result => Constants::TRUE,
    };
}

1; #perlモジュールは真値で終わる必要があるため






















