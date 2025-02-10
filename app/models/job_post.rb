class JobPost < ApplicationRecord
  # アソシエーション
  belongs_to :user  # 施工管理者（投稿者）
  has_many :job_applications, dependent: :destroy  # 作業員の応募
  has_many :chats, dependent: :destroy  # 案件ごとのチャット

  has_one_attached :main_image  # ✅ メイン画像（1枚）

  # バリデーション
  validates :work_title, presence: true
  validates :work_description, presence: true
  validates :work_capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :work_start_date, presence: true
  validates :work_end_date, presence: true
  validates :work_payment, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :work_location, presence: true
  validates :work_status, presence: true, inclusion: { in: %w(recruiting closed) }

  validate :validate_image_attachments  # ✅ 画像のバリデーション

  # ✅ Ransack で検索可能なカラムを許可
  def self.ransackable_attributes(auth_object = nil)
    ["work_location", "work_title", "work_start_date", "work_end_date", "work_status"]
  end

  # ✅ 画像のリサイズ処理（メイン画像 1200px）
  def resized_main_image
    main_image.variant(resize_to_limit: [1200, nil]) if main_image.attached?
  end

  private

  # ✅ 画像のバリデーション（ファイルサイズ・枚数制限）
  def validate_image_attachments
    if main_image.attached?
      if main_image.blob.byte_size > 5.megabytes
        errors.add(:main_image, "は5MB以下にしてください")
      end
      unless main_image.blob.content_type.in?(%w[image/png image/jpeg])
        errors.add(:main_image, "はPNGまたはJPEG形式のみアップロード可能です")
      end
    end
  end
end