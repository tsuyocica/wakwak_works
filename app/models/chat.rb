class Chat < ApplicationRecord
  belongs_to :job_post
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :worker, class_name: "User", foreign_key: "worker_id"

  has_many :messages, dependent: :destroy
end