# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t app .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name app app

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
FROM ruby:3.2

# システムパッケージの更新とインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       nodejs \
                       npm \
                       postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# アプリケーションディレクトリの作成
WORKDIR /app

# 環境変数の設定
ENV RAILS_ENV=development
ENV BUNDLE_PATH=/usr/local/bundle

# Gemfileをコピーして依存関係をインストール
COPY Gemfile ./
RUN bundle install

# アプリケーションのコピー
COPY . .

# ポート3000を公開
EXPOSE 3000

# Rails サーバーを起動
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
