class CreatePublicViews < ActiveRecord::Migration[7.0]
  def change
    create_table :public_views do |t|
      t.references :owner, foreign_key: { to_table: :contacts }
      t.integer :credentials, array: true
      t.string :status, default: 'active'
      t.string :uuid
      t.timestamps
    end
  end
end
