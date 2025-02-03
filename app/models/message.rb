class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :sender, polymorphic: true

  has_many_attached :images  # 複数の画像を添付可能
  has_many_attached :files   # 複数のファイルを添付可能

  validate :content_or_attachment_present

  private

  def content_or_attachment_present
    return if content.present? || images.attached? || files.attached?

    errors.add(:base, "メッセージ、画像、またはファイルのいずれかを入力してください。")
  end
end