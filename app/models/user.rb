class User < ApplicationRecord
  # Deviseの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

# アソシエーション
has_many :job_posts, dependent: :destroy  # 施工管理者が作成した案件
has_many :job_applications, dependent: :destroy  # 作業員が応募した案件

has_one_attached :avatar  # ActiveStorage でアバター画像を管理

# バリデーション
validates :username, presence: true
validates :full_name, presence: true
validates :furigana, presence: true
end
