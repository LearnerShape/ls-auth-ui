class RenameSkillNotesToDescription < ActiveRecord::Migration[7.0]
  def change
    rename_column :skills, :notes, :description
  end
end
