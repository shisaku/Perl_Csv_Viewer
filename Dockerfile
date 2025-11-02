FROM httpd:2.4

# Perlをインストール
# パッケージリストの更新
# perlインストール -y:確認にすべてYesと回答
# CGI.pmのインストール
# apt パッケージマネージャがダウンロードした Debian パッケージファイル（.deb）を削除するコマンド
RUN apt-get update && \
    apt-get install -y perl libcgi-pm-perl && \
    apt-get clean

# CGIモジュールを有効化
# httpd.confにあるcgiを利用可能にする記述のコメントアウトの解除
RUN sed -i 's/#LoadModule cgid_module/LoadModule cgid_module/' /usr/local/apache2/conf/httpd.conf && \
    echo "LoadModule cgi_module modules/mod_cgi.so" >> /usr/local/apache2/conf/httpd.conf

# 既存のScriptAliasをコメントアウト（重複回避）
RUN sed -i 's/^ScriptAlias/#ScriptAlias/' /usr/local/apache2/conf/httpd.conf

# 既存のcgi-binディレクトリ設定を削除
RUN sed -i '/<Directory "\/usr\/local\/apache2\/cgi-bin">/,/<\/Directory>/d' /usr/local/apache2/conf/httpd.conf

# CGI設定を追加
# httpd.confに各種設定を追加
# .htaccessファイルでの設定禁止
# CGIスクリプトの実行を許可
# アクセス許可
RUN echo '<Directory "/usr/local/apache2/cgi-bin">' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    AllowOverride None' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    Options ExecCGI' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    Require all granted' >> /usr/local/apache2/conf/httpd.conf && \
    echo '</Directory>' >> /usr/local/apache2/conf/httpd.conf

# ScriptAlias設定
# URLとファイルパスを結びつける
RUN echo 'ScriptAlias /cgi-bin/ /usr/local/apache2/cgi-bin/' >> /usr/local/apache2/conf/httpd.conf

# ServerName設定（警告解消）
RUN echo 'ServerName localhost' >> /usr/local/apache2/conf/httpd.conf

# EnableSendfile の設定を書き換え（#EnableSendfile on → EnableSendfile Off）
RUN sed -i 's/^#EnableSendfile on/EnableSendfile Off/' /usr/local/apache2/conf/httpd.conf


# ログレベルを詳細に設定
RUN echo 'LogLevel warn' >> /usr/local/apache2/conf/httpd.conf

# エラーログとアクセスログの明示的な設定
RUN echo 'ErrorLog /usr/local/apache2/logs/error_log' >> /usr/local/apache2/conf/httpd.conf
RUN echo 'CustomLog /usr/local/apache2/logs/access_log combined' >> /usr/local/apache2/conf/httpd.conf
# entrypoint設定
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]