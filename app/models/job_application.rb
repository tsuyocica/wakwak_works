class JobApplication < ApplicationRecord
  belongs_to :worker, class_name: "User"
  belongs_to :job_post

  validates :status, presence: true, inclusion: { in: ["pending", "approved", "rejected"] }

  # 応募のステータスを更新（バリデーション付き）
  def update_status!(new_status)
    return false unless %w[pending approved rejected].include?(new_status)

    update!(status: new_status)  # `!` をつけることでエラー時に例外を発生
  end
end