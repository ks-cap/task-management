class AddStateToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :state, :string, default: '未着手', null: false
  end
end
