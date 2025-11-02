package Constants;

use strict;
use warnings;

#=================================================
# 投稿一覧ファイル
#=================================================
use constant{
    # 要素数
    POST_LIST_ITEM_COUNT => 3,
    # 行数最低値
    POST_LIST_MIN_LINE => 1,
    # 投稿内容最大文字数
    POST_CONTENT_MAX_COUNT => 100,
};
#=================================================
# エラーメッセージ
#=================================================
#----------------------
# 投稿一覧ファイル読込
#----------------------
use constant{
    ERR_MSG_NOT_FOUND_POST_LIST_FILE => "投稿一覧ファイルが見つかりませんでした\n",
    ERR_MSG_INVALID_ITEM_COUNT_POST_LIST_FILE => "行目の要素数に誤りがあります\n",
    ERR_MSG_INVALID_LINE_COUNT_POST_LIST_FILE => "投稿一覧ファイルの行数が不正です\n",
};
#----------------------
# 投稿内容チェック
#----------------------
use constant{
    ERR_MSG_POST_CONTENT_NOT_ENTERED => "投稿内容が入力されていません\n",
    ERR_MSG_POST_CONTENT_MAX_COUNT_OVER => "文字数を超過しています。" . POST_CONTENT_MAX_COUNT . "文字以内で入力してください\n",
};
#----------------------
# 新規投稿
#----------------------
use constant{
    ERR_MSG_NOT_FOUND_POST_LIST_ID_COUNT_FILE => "投稿ID管理ファイルが見つかりませんでした\n",
    ERR_MSG_DUPLICATE_ID => "投稿IDが重複しています"
};
#----------------------
# ログファイル
#----------------------
use constant{
    ERR_MSG_NOT_FOUND_LOG_FILE => "Failed to open log file\n",
};
#=================================================
# boolean値
#=================================================
use constant{
    TRUE => 1,
    FALSE => 0
};
#=================================================
# ログファイル
#=================================================
use constant{
    LOG_FILE_PREFIX => "action_log_",
    LOG_FILE_DELIMITER => " ",
    LOG_FILE_EXTENSION => ".log",
    LOG_LEVEL_INFO =>   "[INFO]  ",
    LOG_LEVEL_NOTICE => "[NOTICE]",
    LOG_LEVEL_ERROR =>  "[ERROR] "
};
#=================================================
# ログメッセージ
#=================================================
use constant{
    # post_list.cgi
    LOG_MESSAGE_START_OPEN_POST_LIST => "post_list.cgi START",
    LOG_MESSAGE_END_OPEN_POST_LIST => "post_list.cgi END",
    # PostListHandler.pm
    LOG_MESSAGE_START_GET_ALL_POST_LIST => "PostListHandler.pm get_all_post_list() START",
    LOG_MESSAGE_END_GET_ALL_POST_LIST => "PostListHandler.pm get_all_post_list() END",
    LOG_MESSAGE_ERR_NOT_FOUND_POST_LIST_FILE => "PostListHandler.pm NOT FOUND POST LIST FILE",
    LOG_MESSAGE_START_DELETE_POST_LIST => "PostListHandler.pm delete_post_list() START",
    LOG_MESSAGE_END_DELETE_POST_LIST => "PostListHandler.pm delete_post_list() END",
    LOG_MESSAGE_START_REGISTER_POST_LIST => "PostListHandler.pm register_new_post() START",
    LOG_MESSAGE_END_REGISTER_POST_LIST => "PostListHandler.pm register_new_post() END",
    LOG_MESSAGE_START_CHECK_LINE_COUNT => "PostListHandler.pm check_line_count() START",
    LOG_MESSAGE_END_CHECK_LINE_COUNT => "PostListHandler.pm check_line_count() END",
    LOG_MESSAGE_ERR_CHECK_LINE_COUNT => "PostListHandler.pm check_line_count() ERROR CHECK LINE COUNT",
    LOG_MESSAGE_START_CHECK_ITEM_COUNT => "PostListHandler.pm check_item_count() START",
    LOG_MESSAGE_END_CHECK_ITEM_COUNT => "PostListHandler.pm check_item_count() END",
    LOG_MESSAGE_ERR_CHECK_ITEM_COUNT => "PostListHandler.pm check_item_count() ERROR CHECK ITEM COUNT",
    # delete_post.pl
    LOG_MESSAGE_START_DELETE_POST => "delete_post.pl START",
    LOG_MESSAGE_END_DELETE_POST => "delete_post.pl END",
    LOG_MESSAGE_ERR_JSON_PARSE => "delete_post.pl FAILED JSON PARSE",
    # new_post.cgi
    LOG_MESSAGE_START_OPEN_NEW_POST => "new_post.cgi START",
    LOG_MESSAGE_END_OPEN_NEW_POST => "new_post.cgi END",
    LOG_MESSAGE_START_REGISTER_POST => "new_post.pl START",
    LOG_MESSAGE_END_REGISTER_POST => "new_post.pl END",
    # PostListIdCountHandler.pm
    LOG_MESSAGE_START_GET_CURRENT_ID => "PostListIdCountHandler.pm get_post_list_current_id() START",
    LOG_MESSAGE_END_GET_CURRENT_ID => "PostListIdCountHandler.pm get_post_list_current_id() END",
    LOG_MESSAGE_START_COUNTUP_POST_ID => "PostListIdCountHandler.pm count_up_post_list_id() START",
    LOG_MESSAGE_END_COUNTUP_POST_ID => "PostListIdCountHandler.pm count_up_post_list_id() END",
    LOG_MESSAGE_ERR_NOT_FOUND_POST_LIST_ID_COUNT_FILE => "PostListIdCountHandler.pm NOT FOUND POST LIST ID COUNT FILE",
    # new_post_validation.pm
    LOG_MESSAGE_START_NEW_POST_VALIDATION => "new_post_validation.pm validate() START",
    LOG_MESSAGE_END_NEW_POST_VALIDATION => "new_post_validation.pm validate() END",
    LOG_MESSAGE_VALIDATION_ERR_EMPTY_CHECK => "new_post_validation.pm validate() NOT PASS EMPTY CHECK",
    LOG_MESSAGE_VALIDATION_ERR_CHARACTER_LIMIT_CHECK => "new_post_validation.pm validate() NOT PASS CHARACTER LIMIT CHECK",
    LOG_MESSAGE_VALIDATION_ERR_DUPLICATE_POST_ID_CHECK => "new_post_validation.pm validate() NOT PASS DUPLICATE POST ID CHECK",
    # system_error.cgi
    LOG_MESSAGE_START_OPEN_SYSTEM_ERROR => "system_error.cgi START",
    LOG_MESSAGE_END_OPEN_SYSTEM_ERROR => "system_error.cgi END",
};
1; #perlモジュールは真値で終わる必要があるため














