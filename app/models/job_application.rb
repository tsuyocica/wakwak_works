class JobApplication < ApplicationRecord
  belongs_to :worker, class_name: "User"  # 作業員（Userモデルを参照）
  belongs_to :job_post  # 応募する案件（JobPostモデルを参照）

  validates :status, presence: true, inclusion: { in: ["pending", "approved", "rejected"] }
end
