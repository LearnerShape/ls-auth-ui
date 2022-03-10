class CreateSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.string :skill_type
      t.text :notes
      t.timestamps
    end
  end
end
