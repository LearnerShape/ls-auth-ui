class CreatePrograms < ActiveRecord::Migration[7.0]
  def change
    create_table :programs do |t|
      t.references :creator, foreign_key: { to_table: :contacts }
      t.references :skill
      t.string :status, default: 'created'
      t.timestamps
    end
  end
end
