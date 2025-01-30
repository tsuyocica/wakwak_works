class CreateJobApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :job_applications do |t|
      t.references :worker, null: false, foreign_key: { to_table: :users } # 作業員の外部キー（Userモデルを参照）
      t.references :job_post, null: false, foreign_key: true # 応募する案件の外部キー（JobPostモデルを参照）
      t.string :status, null: false, default: "pending" # 応募の状態（デフォルト: "pending"）（pending:保留中, approved:承認, rejected:却下）

      t.timestamps
    end
  end
end