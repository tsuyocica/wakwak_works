class Chat < ApplicationRecord
  belongs_to :job_post
  belongs_to :owner
  belongs_to :worker
end
