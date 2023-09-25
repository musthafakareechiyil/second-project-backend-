class AddBlockAndDeletedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :blocked, :boolean, default: false
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  end
end
