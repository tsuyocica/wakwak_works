class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: { to_table: :users } # `users` テーブルを参照
      t.references :worker, null: false, foreign_key: { to_table: :users } # `users` テーブルを参照

      t.timestamps
    end
  end
end
