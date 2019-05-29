# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name, null: false, limit: 30
      t.text :description, limit: 100

      t.timestamps
    end
  end
end
