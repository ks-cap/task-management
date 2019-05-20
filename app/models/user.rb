# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  # presence: 必須のデータがちゃんと入っているか
  validates :name, presence: true
  # uniqueness: データが一意になっているか
  validates :email, presence: true, uniqueness: true

  validates :password, presence: true
  validates :password_digest, presence: true

  # UserとTaskは１対多の関係
  has_many :tasks
  has_many :owner_tasks, class_name: 'Task', foreign_key: :owner_id
  has_one :user_group
  has_one :group, through: :user_group
end
