# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups

  validates :name, presence: true, length: { maximum: 255 }
end
