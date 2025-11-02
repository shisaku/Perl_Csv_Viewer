package new_post_validation;

use strict;
use warnings;
# モジュール系
use lib '/usr/local/apache2/cgi-bin/module';
use BaseApp;
use Constants;
use Data::Dumper;
use PostListHandler;
use Encode 'decode';
#####################################################
# 投稿内容をチェック
# @param 投稿内容
# @param 投稿ID
# @return:成否,エラーメッセージ(ハッシュリファレンス)
#####################################################
sub validate{
    LogHandler::output_info_log(Constants::LOG_MESSAGE_START_NEW_POST_VALIDATION);
    my ($post_content,$post_id) = @_; # 投稿内容
    #----------------------
    # 未入力チェック
    #----------------------
    if($post_content eq ""){
        LogHandler::output_notice_log(Constants::LOG_MESSAGE_VALIDATION_ERR_EMPTY_CHECK);
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_NEW_POST_VALIDATION);
        return {is_validate => Constants::FALSE,validation_message => Constants::ERR_MSG_POST_CONTENT_NOT_ENTERED};
    };
    #----------------------
    # 文字数制限チェック
    #----------------------
    my $character_count = length decode('UTF-8', $post_content);
    if($character_count > Constants::POST_CONTENT_MAX_COUNT){
        LogHandler::output_notice_log(Constants::LOG_MESSAGE_VALIDATION_ERR_CHARACTER_LIMIT_CHECK);
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_NEW_POST_VALIDATION);
        return {is_validate => Constants::FALSE,validation_message => Constants::ERR_MSG_POST_CONTENT_MAX_COUNT_OVER};
    };
    #----------------------
    # ID重複チェック
    #----------------------
    my $duplicate_result = PostListHandler::not_duplicate_post_id($post_id);
    my $is_get_result = $duplicate_result->{result};
    unless($is_get_result){
        my $error_message = $duplicate_result->{error_message};
        LogHandler::output_notice_log(Constants::LOG_MESSAGE_VALIDATION_ERR_DUPLICATE_POST_ID_CHECK);
        LogHandler::output_info_log(Constants::LOG_MESSAGE_END_NEW_POST_VALIDATION);
        return {is_validate => Constants::FALSE,validation_message => $error_message};
    };
    #----------------------
    # 成功
    #----------------------
    LogHandler::output_info_log(Constants::LOG_MESSAGE_END_NEW_POST_VALIDATION);
    return {is_validate => Constants::TRUE};
}
1;