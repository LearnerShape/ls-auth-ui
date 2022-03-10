class CreateCredentials < ActiveRecord::Migration[7.0]
  def change
    create_table :credentials do |t|
      t.references :skill
      t.references :holder, foreign_key: { to_table: :contacts}
      t.string :status, default: 'draft'
      t.timestamps
    end
  end
end
