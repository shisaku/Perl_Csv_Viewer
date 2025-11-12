package Constants;

use strict;
use warnings;

#=================================================
# ログファイル読み込みエラー
#================================================
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
    # system_error.cgi
    LOG_MESSAGE_START_OPEN_SYSTEM_ERROR => "system_error.cgi START",
    LOG_MESSAGE_END_OPEN_SYSTEM_ERROR => "system_error.cgi END",
    # input_csv.cgi
    LOG_MESSAGE_START_OPEN_INPUT_CSV => "input_csv.cgi START",
    LOG_MESSAGE_END_OPEN_INPUT_CSV => "input_csv.cgi END",
    # csv_viewer.cgi
    LOG_MESSAGE_START_OPEN_CSV_VIEWER => "csv_viewer.cgi START",
    LOG_MESSAGE_END_OPEN_CSV_VIEWER => "csv_viewer.cgi END",
    LOG_MESSAGE_ERR_CSV_UPLOAD => "csv_viewer.cgi CSV UPLOAD ERROR",
};
1; #perlモジュールは真値で終わる必要があるため














