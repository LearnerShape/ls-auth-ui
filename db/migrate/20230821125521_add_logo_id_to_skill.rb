class AddLogoIdToSkill < ActiveRecord::Migration[7.0]
  def change
    add_column :skills, :logo_id, :bigint
    add_index :skills, :logo_id
  end
end
