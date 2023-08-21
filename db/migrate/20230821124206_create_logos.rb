class CreateLogos < ActiveRecord::Migration[7.0]
  def change
    create_table :logos do |t|
      t.references :creator, foreign_key: { to_table: :users }
      t.string :status, default: 'uploaded'
      t.timestamps
    end
  end
end
