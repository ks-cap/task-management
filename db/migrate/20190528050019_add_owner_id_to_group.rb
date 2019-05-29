class AddOwnerIdToGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :owner_id, :integer, null: false
  end
end
