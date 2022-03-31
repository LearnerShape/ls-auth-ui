class AddApiIdToAuthentications < ActiveRecord::Migration[7.0]
  def change
    remove_column :credentials, :api_id
    add_column :authentications, :api_id, :string
  end
end
