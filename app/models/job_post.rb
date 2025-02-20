class JobPost < ApplicationRecord
  # 仮想的な属性を追加
  attr_accessor :remove_main_image

  # アソシエーション
  belongs_to :user  # 施工管理者（投稿者）
  has_many :job_applications, dependent: :destroy  # 作業員の応募
  has_many :chats, dependent: :destroy  # 案件ごとのチャット

  has_one_attached :main_image  # ✅ メイン画像（1枚）

  # バリデーション
  validates :work_title, presence: true, length: { maximum: 40 }
  validates :work_description, presence: true, length: { maximum: 2_000 }
  validates :work_capacity, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 10 }
  validates :work_start_date, presence: true
  validates :work_end_date, presence: true
  validates :work_payment, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 20_000, less_than_or_equal_to: 9_999_999 }
  validates :work_location, presence: true
  validates :work_status, presence: true, inclusion: { in: %w(recruiting closed) }

  validate :validate_dates  # ✅ 日付のバリデーション
  validate :validate_image_attachments  # ✅ 画像のバリデーション

  # ✅ Google Maps API を使って緯度経度を取得
  before_validation :set_geocode, if: -> { work_location.present? && work_location_changed? }

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
      unless main_image.blob.content_type.in?(%w[image/png image/jpeg image/jpg])
        errors.add(:main_image, "はPNGまたはJPEG形式のみアップロード可能です")
      end
    end
  end

  # ✅ Google Maps API で緯度経度を取得（バリデーション前に実行）
  def set_geocode
    results = Geocoder.search(work_location)
    if results.present?
      self.latitude = results.first.coordinates[0]
      self.longitude = results.first.coordinates[1]
    else
      errors.add(:work_location, "が正しくありません。存在する住所を入力してください。")
    end
  end

  # ✅ 開始日と終了日のバリデーション
  def validate_dates
    if work_start_date.present? && work_start_date < Date.tomorrow
      errors.add(:work_start_date, "は明日以降の日付を選択してください。")
    end

    if work_end_date.blank?
      errors.add(:work_end_date, "を入力してください。")
    elsif work_start_date.present? && work_end_date < work_start_date
      errors.add(:work_end_date, "は作業開始日以降の日付を選択してください。")
    end
  end
end