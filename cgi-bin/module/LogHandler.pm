package LogHandler;

use strict;
use warnings;
# モジュール系
use lib '/usr/local/apache2/cgi-bin/module';
use BaseApp;
use Constants;
use Data::Dumper;
#####################################################
# 共通ログ出力関数
# @param $log_level ログレベル（INFO/ERROR/NOTICE）
# @param $message ログメッセージ
#####################################################
sub _output_log {
    my ($log_level, $message) = @_;
    
    #----------------------
    # logの中身を作成
    #----------------------
    # ファイルパス
    my $current_date = BaseApp::get_current_date();
    my $log_file_name = Constants::LOG_FILE_PREFIX . $current_date . Constants::LOG_FILE_EXTENSION;
    my $log_file_full_path = BaseApp::LOG_FOLDER_PATH . $log_file_name;
    
    # logの内容
    my $current_datetime = BaseApp::get_current_datetime;
    my $log_content = $log_level . Constants::LOG_FILE_DELIMITER . $current_datetime . Constants::LOG_FILE_DELIMITER . $message . "\n";
    
    #----------------------
    # logファイルを新規作成するか判定し、log書き込み
    #----------------------
    my $file_mode = is_create_log_file($log_file_full_path) ? ">>" : ">";
    
    eval {
        my $file_handler;
        open($file_handler, $file_mode, $log_file_full_path) 
            or die(Constants::ERR_MSG_NOT_FOUND_LOG_FILE);
        print $file_handler $log_content;
        close($file_handler);
    };
    
    #----------------------
    # 例外処理
    #----------------------
    if ($@) {
        chomp $@;
        # /var/log/apache2/error.logへ出力
        print STDERR $@;
    }
}

#####################################################
# INFOlogを出力
#####################################################
sub output_info_log {
    my ($message) = @_;
    _output_log(Constants::LOG_LEVEL_INFO, $message);
}

#####################################################
# Errorlogを出力
#####################################################
sub output_error_log {
    my ($message) = @_;
    _output_log(Constants::LOG_LEVEL_ERROR, $message);
}

#####################################################
# Noticelogを出力
#####################################################
sub output_notice_log {
    my ($message) = @_;
    _output_log(Constants::LOG_LEVEL_NOTICE, $message);
}
#####################################################
# logファイルを作成するか判定（日ごとにlogファイルを作成する）
# @param logファイルパス
# @return true（存在する）
# @return false（存在しない）
#####################################################
sub is_create_log_file{
    (my $log_file_full_path) = @_;
    my $is_exist_file;
    # 同名のlogファイルが存在するか判定
    if(-e $log_file_full_path){
        return $is_exist_file = Constants::TRUE;
    }else{
        return $is_exist_file = Constants::FALSE;
    };
}
1; #perlモジュールは真値で終わる必要があるため