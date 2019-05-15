class AddStateToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :state, :string, default: '---', null: false
  end
end
