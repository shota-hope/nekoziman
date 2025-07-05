# 🐱 ねこじまん (Nekoziman)

猫の画像とコメントを投稿し、ChatGPT で自動的に褒めてもらえるアプリです。

## 📋 技術構成

- **フロントエンド**: React Native (Expo)
- **バックエンド**: Ruby on Rails (API)
- **データベース**: PostgreSQL
- **キャッシュ**: Redis
- **画像ストレージ**: Cloudinary
- **AI**: OpenAI GPT-4 Vision API
- **インフラ**: Docker & Docker Compose

## 🚀 環境構築

### 1. 前提条件

- Docker Desktop がインストール済み
- Git がインストール済み
- Node.js 18.16.0 以上

### 2. プロジェクトのクローン

```bash
git clone <repository-url>
cd nekoziman
```

### 3. 環境変数の設定

```bash
# backendディレクトリに.envファイルを作成
cd backend
cp .env.sample .env
```

`.env`ファイルを編集し、以下の環境変数を設定してください：

```env
# データベース設定
DB_HOST=db
DATABASE_URL=postgresql://nekoziman:password@db:5432/nekoziman_development

# Redis設定
REDIS_URL=redis://redis:6379/0

# Cloudinary設定
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# OpenAI API設定
OPENAI_API_KEY=your_openai_api_key

# JWT設定
JWT_SECRET_KEY=your_jwt_secret_key

# Rails設定
RAILS_ENV=development
RAILS_MAX_THREADS=5
```

### 4. Docker 環境の起動

```bash
# プロジェクトルートに戻る
cd ..

# Docker環境を起動
docker-compose up -d

# Gemのインストール
docker-compose exec api bundle install

# データベースのセットアップ
docker-compose exec api rails db:create
docker-compose exec api rails db:migrate
docker-compose exec api rails db:seed
```

### 5. React Native アプリの起動

```bash
cd frontend
npm install
npm run start
```

## 🛠️ 開発

### Rails API (Backend)

```bash
# Rails コンソール
docker-compose exec api rails console

# ログの確認
docker-compose logs -f api

# テストの実行
docker-compose exec api bundle exec rspec
```

### React Native (Frontend)

```bash
cd frontend

# iOS シミュレーター
npm run ios

# Android エミュレーター
npm run android

# Web
npm run web
```

## 📁 プロジェクト構成

```
nekoziman/
├── backend/              # Rails API
│   ├── app/
│   ├── config/
│   ├── db/
│   ├── Gemfile
│   ├── Dockerfile
│   └── .env
├── frontend/             # React Native App
│   ├── App.js
│   ├── package.json
│   └── ...
├── docker-compose.yml    # Docker構成
└── README.md
```

## 🔧 API エンドポイント

### 認証

- `POST /api/v1/auth/signup` - ユーザー登録
- `POST /api/v1/auth/login` - ログイン
- `DELETE /api/v1/auth/logout` - ログアウト

### 投稿

- `GET /api/v1/posts` - 投稿一覧
- `POST /api/v1/posts` - 投稿作成
- `GET /api/v1/posts/:id` - 投稿詳細
- `PUT /api/v1/posts/:id` - 投稿更新
- `DELETE /api/v1/posts/:id` - 投稿削除

### いいね・コメント

- `POST /api/v1/posts/:id/likes` - いいね
- `DELETE /api/v1/posts/:id/likes` - いいね削除
- `POST /api/v1/posts/:id/comments` - コメント投稿
- `GET /api/v1/posts/:id/comments` - コメント一覧

## 🐛 トラブルシューティング

### Docker 関連

- `docker-compose down -v` でボリュームを削除してリセット
- `docker-compose up --build` でイメージを再ビルド

### Rails 関連

- `docker-compose exec api bundle install` で Gem を再インストール
- `docker-compose exec api rails db:drop db:create db:migrate` で DB リセット

## 📝 開発メモ

- Rails API は `http://localhost:3000` で起動
- PostgreSQL は `localhost:5432` で起動
- Redis は `localhost:6379` で起動
- React Native は Expo Go アプリで開発
