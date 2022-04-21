class MoveApiIdFromUserToContact < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :api_id
    add_column :contacts, :api_id, :string
  end
end
