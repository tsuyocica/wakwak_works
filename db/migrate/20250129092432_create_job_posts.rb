class CreateJobPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :job_posts do |t|
      t.references :user, null: false, foreign_key: true  # 施工管理者（投稿者）の外部キー

      t.string :work_title, null: false   # 仕事のタイトル
      t.text :work_description, null: false # 仕事内容の説明
      t.integer :work_capacity, null: false # 募集人数

      t.date :work_start_date, null: false # 作業開始日
      t.date :work_end_date, null: false   # 作業終了日

      t.integer :work_payment, null: false # 報酬（整数、日本円）
      t.string :work_location, null: false # 作業現場の住所
      t.string :work_status, default: "recruiting" # 募集状況（"recruiting": 募集中, "closed": 締め切り）

      t.timestamps
    end
  end
end
