#!/usr/bin/env bash

# 環境変数の設定
export RAILS_ENV=production
export NODE_ENV=production

# 依存関係のインストール
bundle install --without development test
yarn install --check-files

# データベースのマイグレーション（必要なら）
bundle exec rails db:migrate

# 🚀 **アセットのプリコンパイル**
bundle exec rails assets:clobber
bundle exec rails assets:precompile
