class AddNameToContact < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :name, :string
  end
end
