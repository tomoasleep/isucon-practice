サーバ環境
EC2環境にて、Amazon Linuxをセットアップし、MySQLや各言語のインタプリタもインストールしてあります。

「isu-user」ユーザのホームディレクトリに「isucon」ディレクトリがあります。アプリケーションのコードは「~/isucon/webapp」以下にあります

実装言語の切り替え
TCP Port 80でApacheが起動し、Port 5000でWebアプリケーションがsupervisord経由で起動されています。初期設定では Ruby の実装が起動しています。実装を切り替えるには「~/isucon/run.ini」を編集します。

```
[program:isucon_node]
directory=/home/isu-user/isucon/webapp/nodejs
command=/home/isu-user/isucon/env.sh node server.js
user=isu-user
stdout_logfile=/tmp/isucon.node.log
stderr_logfile=/tmp/isucon.node.log
stopsignal=INT
autostart=false ←ここを変更する

[program:isucon_ruby]
directory=/home/isu-user/isucon/webapp/ruby
command=/home/isu-user/isucon/env.sh bundle exec foreman start
user=isu-user
stdout_logfile=/tmp/isucon.ruby.log
stderr_logfile=/tmp/isucon.ruby.log
autostart=true ←ここを変更する
```

node.js実装に切り替えるには Ruby実装の autostartをfalseにし、node実装のautostartをtrueにして保存します。その後supervisordをreloadします

```
$ sudo supervisorctl reload
```

以上で実装が切り替わります。アプリケーションを再起動する場合は上のreloadコマンドか

```
$ sudo supervisorctl restart isucon_${実装名}
```

としてください

PHP実装のみ他言語と起動方法が異なるため、「~/isucon/webapp/php/README.md」 を参照してください

データベースについて
MySQLが動作しています。MySQLのログインは

ユーザ名「isu-user」、パスワードなし
ユーザ名「isucon」、パスワードなし
ユーザ名「root」、パスワードなし
このいずれでも出来ます

```
$ mysql -u isu-user isucon
```

ベンチマークの設定と実行
ベンチマークの実行は上の「ベンチマーク開始」ボタンをクリックしてください。1回のベンチマークに1分程度かかります

ベンチマークを開始するとまず、データベースの初期化が行われます。その後アプリケーションに対してアクセスをします。データベースの初期化のあとにインデックスの作成などを行いたい場合は、「~/isucon/init.sh」に書いてください

アプリケーションのID/Password
アプリケーションにSignInする際のID/Passwordは、isucon1/isucon1です
