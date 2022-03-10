class CreateAuthentications < ActiveRecord::Migration[7.0]
  def change
    create_table :authentications do |t|
      t.references :credential
      t.references :authenticator, foreign_key: { to_table: :contacts }
      t.string :status, default: 'invited'
      t.timestamps
    end
  end
end
