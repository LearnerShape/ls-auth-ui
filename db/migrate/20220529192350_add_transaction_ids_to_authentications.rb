class AddTransactionIdsToAuthentications < ActiveRecord::Migration[7.0]
  def change
    add_column :authentications, :submission_transaction_id, :string
    add_column :authentications, :revocation_transaction_id, :string
  end
end
