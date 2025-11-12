#!/bin/bash
#----------------------
# ファイルが存在する場合のみ権限・改行コードを変更
#----------------------
# cgi・pm・pl
if [ -d "/usr/local/apache2/cgi-bin" ]; then
    find /usr/local/apache2/cgi-bin -name "*.cgi" -exec dos2unix {} \; 2>/dev/null || true
    find /usr/local/apache2/cgi-bin -name "*.cgi" -exec chmod 755 {} \; 2>/dev/null || true
    find /usr/local/apache2/cgi-bin -name "*.pm" -exec dos2unix {} \; 2>/dev/null || true
    find /usr/local/apache2/cgi-bin -name "*.pm" -exec chmod 755 {} \; 2>/dev/null || true
    find /usr/local/apache2/cgi-bin -name "*.pl" -exec dos2unix {} \; 2>/dev/null || true
    find /usr/local/apache2/cgi-bin -name "*.pl" -exec chmod 777 {} \; 2>/dev/null || true
fi
# css
if [ -d "/usr/local/apache2/htdocs/css" ]; then
    find /usr/local/apache2/htdocs/css/ -name "*.css" -exec dos2unix {} \; 2>/dev/null || true
    find /usr/local/apache2/htdocs/css/ -name "*.css" -exec chmod 644 {} \; 2>/dev/null || true
fi
# js
if [ -d "/usr/local/apache2/htdocs/js" ]; then
    find /usr/local/apache2/htdocs/js/ -name "*.js" -exec dos2unix {} \; 2>/dev/null || true
    find /usr/local/apache2/htdocs/js/ -name "*.js" -exec chmod 644 {} \; 2>/dev/null || true
fi
# csv
if [ -d "/usr/local/apache2/data/input_files/" ]; then
    find /usr/local/apache2/data/input_files/ -name "*.csv" -exec dos2unix {} \; 2>/dev/null || true
    find /usr/local/apache2/data/input_files/ -name "*.csv" -exec chmod 666 {} \; 2>/dev/null || true
fi
# log
if [ -d "/var/log/action_log/" ]; then
    # ディレクトリの権限を変更（書き込み可能に）
    chmod 777 /var/log/action_log/ 2>/dev/null || true
    find /var/log/action_log/ -name "*.log" -exec dos2unix {} \; 2>/dev/null || true
    find /var/log/action_log/ -name "*.log" -exec chmod 644 {} \; 2>/dev/null || true
fi
httpd -t
exec httpd -D FOREGROUND
