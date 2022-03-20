class AddApiIdToSkillsAndCredentials < ActiveRecord::Migration[7.0]
  def change
    add_column :skills, :api_id, :string
    add_column :credentials, :api_id, :string
  end
end
