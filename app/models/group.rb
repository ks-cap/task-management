# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true, length: { maximum: 255 }
end
