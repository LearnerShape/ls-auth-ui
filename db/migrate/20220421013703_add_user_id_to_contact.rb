class AddUserIdToContact < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :user_id, :bigint
    add_index :contacts, :user_id
  end
end
