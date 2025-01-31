class ChangeRoleToArrayInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :role, :json, null:false # 役割をstring→array型へ変更
  end
end
