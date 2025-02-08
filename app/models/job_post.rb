class JobPost < ApplicationRecord
  # アソシエーション
  belongs_to :user  # 施工管理者（投稿者）
  has_many :job_applications, dependent: :destroy  # 作業員の応募
  has_many :chats, dependent: :destroy  # 案件ごとのチャット

  has_one_attached :main_image  # ActiveStorage でメイン画像を管理
  has_many_attached :sub_images # 現場写真（最大10枚）

  # バリデーション
  validates :work_title, presence: true
  validates :work_description, presence: true
  validates :work_capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :work_start_date, presence: true
  validates :work_end_date, presence: true
  validates :work_payment, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :work_location, presence: true
  validates :work_status, presence: true, inclusion: { in: %w(recruiting closed) }
  validate :validate_image_attachments

  # Ransack で検索可能なカラムを許可
  def self.ransackable_attributes(auth_object = nil)
    ["work_location", "work_title", "work_start_date", "work_end_date", "work_status"]
  end

  # ✅ 画像のリサイズ処理（横幅1000px以内）
  def resized_main_image
    main_image.variant(resize_to_limit: [1000, nil]) if main_image.attached?
  end

  def resized_sub_images
    sub_images.map { |img| img.variant(resize_to_limit: [1000, nil]) } if sub_images.attached?
  end

  private

  # 画像のバリデーション（ファイルサイズ・枚数制限）
  def validate_image_attachments
    if main_image.attached?
      errors.add(:main_image, "は5MB以下にしてください") if main_image.blob.byte_size > 5.megabytes
    end

    if sub_images.attached?
      errors.add(:sub_images, "は10枚以下にしてください") if sub_images.count > 10
      sub_images.each do |image|
        errors.add(:sub_images, "の各画像は5MB以下にしてください") if image.blob.byte_size > 5.megabytes
      end
    end
  end
end
