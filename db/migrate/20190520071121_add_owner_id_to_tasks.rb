# frozen_string_literal: true

class AddOwnerIdToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :owner_id, :integer, null: false
  end
end
