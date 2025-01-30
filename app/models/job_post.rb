class JobPost < ApplicationRecord
  # アソシエーション
  belongs_to :user  # 施工管理者（投稿者）
  has_many :job_applications, dependent: :destroy  # 作業員の応募
  has_many :chats, dependent: :destroy  # 案件ごとのチャット

  # バリデーション
  validates :work_title, presence: true
  validates :work_description, presence: true
  validates :work_capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :work_start_date, presence: true
  validates :work_end_date, presence: true
  validates :work_payment, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :work_location, presence: true
  validates :work_status, presence: true, inclusion: { in: %w(recruiting closed) }
end
