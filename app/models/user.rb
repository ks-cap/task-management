# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :tasks
  has_many :owner_tasks, class_name: 'Task', foreign_key: :owner_id
  has_one :user_group, dependent: :destroy
  has_one :group, through: :user_group
  has_one_attached :image

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }
  validates :password_digest, presence: true

  validate :image_type

  private

  def image_type
    if image.attached?
      errors.add(:image, I18n.t('errors.messages.task.image.different_type', locale: :ja)) unless image.content_type.in?(%("image/jpeg image/png"))
    end
  end

end
