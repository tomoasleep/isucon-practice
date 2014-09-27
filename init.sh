#!/bin/sh
set -e

#データ投入後になにかしらの作業をしたい場合はこのシェルスクリプトに書いてください
cat << 'EOF' | mysql -u isucon isucon
ALTER TABLE memos ADD COLUMN title text;
UPDATE memos SET
  title = substring_index(content, "\n", 1);
EOF

