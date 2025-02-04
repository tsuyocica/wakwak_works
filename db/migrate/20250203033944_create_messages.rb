class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true # チャットルームID
      t.references :sender, polymorphic: true, null: false # 送信者 (ユーザー or 管理者など)
      t.text :content, null: true # メッセージ内容（任意）

      t.timestamps
    end
  end
end