class User < ApplicationRecord
  # Deviseの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :job_posts, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_one_attached :avatar  # ActiveStorage でアバター画像を管理

  # バリデーション
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password, format: { with: /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/, message: "は半角英数字の両方を含める必要があります" }, allow_nil: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :furigana, presence: true, format: { with: /\A[\p{hiragana}ー]+\z/, message: "はひらがなのみで入力してください" }, length: { minimum: 2, maximum: 30 }
  validates :birth_date, presence: true
  validate  :validate_age
  validates :role, presence: true, inclusion: { in: ["施工管理者", "作業員"], message: "は'施工管理者'または'作業員'を指定してください" }
  validates :experience, presence: true, length: { maximum: 2000 }
  validates :qualification, presence: true, length: { maximum: 50 }

  # アバター画像のバリデーション
  validate :avatar_validation

  private

  # 18歳未満の登録を防ぐ
  def validate_age
    return if birth_date.blank?

    if birth_date > 18.years.ago
      errors.add(:birth_date, "は18歳以上である必要があります")
    end
  end

  # アバター画像のバリデーション
  def avatar_validation
    return unless avatar.attached?

    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, "のサイズは5MB以下にしてください")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(avatar.blob.content_type)
      errors.add(:avatar, "はJPEGまたはPNG形式のみアップロードできます")
    end
  end

  # 🔹 `password` のバリデーションを適用する条件を指定
  def password_required?
    new_record? || password.present?
  end
end