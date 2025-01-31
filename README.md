# アプリケーション名

WakWakWorks

# アプリケーション概要

施工管理者と作業員をマッチング するアプリです。施工管理者は、案件を投稿し、作業
内容・募集人数・報酬・作業日程を設定できます。作業員は案件を閲覧し、チャットを通
じて応募。施工管理者が承認するとマッチングが成立します。作業完了後はレビュー機能
で評価を記録。リアルタイムのチャット機能も搭載し、スムーズなやり取りが可能。短期
・単発の仕事探し にも最適な、建設業界向けのマッチングサービスです。

# URL

https://wakwak-works.onrender.com/

# テスト用アカウント

ログイン機能等を実装した場合は、ログインに必要な情報を記載。 Basic 認証等を設け
ている場合は、その ID/Pass も記載すること。

# 利用方法

このアプリケーションの利用方法を記載。説明が長い場合は、箇条書きでリスト化するこ
と。

# アプリケーションを作成した背景

このアプリケーションを通じて、どのような人の、どのような課題を解決しようとしてい
るのかを記載。

# 実装した機能についての画像や GIF およびその説明

実装した機能について、それぞれどのような特徴があるのかを列挙する形で記載。画像は
Gyazo で、GIF は GyazoGIF で撮影すること。

# 実装予定の機能

洗い出した要件の中から、今後実装予定の機能がある場合は、その機能を記載。

# データベース設計

ER 図を添付。（ゆくゆく形になってきたら ER 図を完成させる。現状は以下の通り）

## **データベース設計（最新版）**

## **🗂 テーブル一覧**

- **Users**（ユーザー管理機能）
- **JobPosts**（作業員募集機能）
- **JobApplications**（作業員の応募機能）
- **Reviews**（レビュー管理機能）
- **Chats**（案件ごとのチャット機能）
- **Messages**（メッセージ管理機能）

---

## **📝 Users テーブル（ユーザー）**

| Column             | Type     | Options                   | 説明                                                        |
| ------------------ | -------- | ------------------------- | ----------------------------------------------------------- |
| email              | string   | null: false, unique: true | メールアドレス                                              |
| encrypted_password | string   | null: false               | パスワード（Devise）                                        |
| username           | string   | null: false, unique: true | ユーザー名                                                  |
| full_name          | string   | null: false               | 本名                                                        |
| furigana           | string   | null: false               | ふりがな                                                    |
| birth_date         | date     | null: false               | 生年月日                                                    |
| role               | json     | null: false               | **ユーザーの役割（["施工管理者", "作業員"] など複数可能）** |
| experience         | text     | null: false               | 経験・スキル                                                |
| qualification      | string   |                           | 資格（例: 第二種電気工事士）                                |
| created_at         | datetime | null: false               | 作成日時                                                    |
| updated_at         | datetime | null: false               | 更新日時                                                    |

✅ **アソシエーション**

- `has_many :job_posts, dependent: :destroy`
- `has_many :job_applications, dependent: :destroy`
- `has_many :received_reviews, class_name: 'Review', foreign_key: 'reviewee_id', dependent: :destroy`
- `has_many :given_reviews, class_name: 'Review', foreign_key: 'reviewer_id', dependent: :destroy`

---

## **📝 JobPosts テーブル（作業案件）**

| Column           | Type     | Options                        | 説明                          |
| ---------------- | -------- | ------------------------------ | ----------------------------- |
| user_id          | bigint   | null: false, foreign_key: true | 施工管理者（投稿者）の ID     |
| work_title       | string   | null: false                    | 仕事のタイトル                |
| work_description | text     | null: false                    | 仕事内容の説明                |
| work_capacity    | integer  | null: false                    | 募集人数                      |
| work_start_date  | date     | null: false                    | 作業開始日                    |
| work_end_date    | date     | null: false                    | 作業終了日                    |
| work_payment     | integer  | null: false                    | 報酬（日本円）                |
| work_location    | string   | null: false                    | 作業現場の住所                |
| work_status      | string   | default: "recruiting"          | 募集状況（募集中 / 受付終了） |
| created_at       | datetime | null: false                    | 作成日時                      |
| updated_at       | datetime | null: false                    | 更新日時                      |

✅ **アソシエーション**

- `belongs_to :user`
- `has_many :job_applications, dependent: :destroy`
- `has_many :chats, dependent: :destroy`

---

## **📝 JobApplications テーブル（作業員の応募）**

| Column      | Type     | Options                        | 説明                                                |
| ----------- | -------- | ------------------------------ | --------------------------------------------------- |
| user_id     | bigint   | null: false, foreign_key: true | **応募した作業員の ID**                             |
| job_post_id | bigint   | null: false, foreign_key: true | 応募先の案件 ID                                     |
| status      | string   | default: "pending"             | **応募のステータス（pending, approved, rejected）** |
| created_at  | datetime | null: false                    | 作成日時                                            |
| updated_at  | datetime | null: false                    | 更新日時                                            |

✅ **アソシエーション**

- `belongs_to :user`
- `belongs_to :job_post`

※ `message` カラムは後から実装予定。

---

## **📝 Reviews テーブル（レビュー）**

| Column      | Type     | Options                                        | 説明                              |
| ----------- | -------- | ---------------------------------------------- | --------------------------------- |
| reviewer_id | bigint   | null: false, foreign_key: { to_table: :users } | **レビューをしたユーザーの ID**   |
| reviewee_id | bigint   | null: false, foreign_key: { to_table: :users } | **レビューを受けるユーザーの ID** |
| rating      | float    | null: false                                    | 評価スコア（1.0〜5.0）            |
| comment     | text     |                                                | レビューのコメント                |
| created_at  | datetime | null: false                                    | 作成日時                          |
| updated_at  | datetime | null: false                                    | 更新日時                          |

✅ **アソシエーション**

- `belongs_to :reviewer, class_name: 'User'`
- `belongs_to :reviewee, class_name: 'User'`

---

## **📌 変更点**

1. **JobApplications から `message` カラムを削除し、後から実装する形に変更**
2. **その他の構成は変更なし**

✅ **ユーザーが両方の役割を持てるようになった** ✅ **マッチングとチャットの管理
がしやすくなった** ✅ **応募状況やチャットの状態を適切に管理できる**

# 画面遷移図

画面遷移図を添付。

# 開発環境

使用した言語・サービスを記載。

# ローカルでの動作方法

`git clone` してから、ローカルで動作をさせるまでに必要なコマンドを記載。

# 工夫したポイント

- Bootstrap を利用したデザイン
- Ajax を使うことでチャット機能を追加、またページ遷移なしに動的に更新可能（予定
  ）
- GoogleMap API を利用した現在地から現場までの距離の把握、現場情報のプロット（予
  定）

タスク管理

# 改善点

より改善するとしたらどこか、それはどのようにしてやるのか。

# 制作時間

アプリケーションを制作するのにかけた時間を記載。
