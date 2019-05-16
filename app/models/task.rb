class Task < ApplicationRecord

  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 100 }

  validate :validate_name_not_including_comma
  validate :image_type

  # UserとTaskは１対多の関係
  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  has_one_attached :image

  enum state: { 未着手: '未着手', '着手中': '着手中', 完了: '完了' }

  # ransack使用時の制約追加
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at deadline state]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end


  private
  def validate_name_not_including_comma
    errors.add(:name, I18n.t('activerecord.errors.messages.task.name.comma', locale: :ja)) if name&.include?(',') || name&.include?('、')
  end

  def image_type
    if image.attached?
     # errors.add(:image, I18n.t('activerecord.errors.messages.task.image.no_file', locale: :ja))
      if !image.content_type.in?(%("image/jpeg image/png"))
        errors.add(:image, I18n.t('activerecord.errors.messages.task.image.different_type', locale: :ja))
      end
    end
  end
end
