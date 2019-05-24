# frozen_string_literal: true

class Task < ApplicationRecord
  # enum state: { 未着手: '未着手', '着手中': '着手中', 完了: '完了' }
  enum state: { waiting: 0, working: 1, completed: 2 }
  belongs_to :user
  belongs_to :owner, class_name: 'User'
  has_one_attached :image

  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 100 }
  validates :state, presence: true
  validate :validate_name_not_including_comma
  validate :deadline_cannot_be_set_before_now, if: -> { deadline.present? }
  validate :image_type

  scope :recent, -> { order(created_at: :desc) }
  scope :with_group, ->(group) { includes(user: :group).where(groups: { id: group&.id }) }
  scope :expired, -> { where('deadline <= ?', Date.today) }
  # ransack使用時の制約追加
  def self.ransackable_attributes(_auth_object = nil)
    %w[name created_at deadline state]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def self.csv_attributes
    %w[user_id name description deadline state created_at updated_at owner_id]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      # allメソッドで全タスクを取得し１レコードごとにCSVの１行を出力するその際は属性ごとにTaskオブジェクトから属性値を取得しcsvに与えている。
      all.each do |task|
        csv << csv_attributes.map { |attr| task.send(attr) }
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = Task.new
      task.attributes = row.to_hash.slice(*csv_attributes)
      begin
        task.save!
      rescue StandardError => e
        # errors.add("CSVによるページ一括登録に失敗しました(#{e.message})")
        Rails.logger.error("Can not save the uploaded file #{e.message}")
      end
    end
  end

  def editable?(target_user)
    if target_user.admin?
      true
    elsif target_user.group.present?
      user.group == target_user.group
    else
      user == target_user
    end
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, I18n.t('errors.messages.task.name.comma', locale: :ja)) if name&.include?(',') || name&.include?('、')
  end

  def deadline_cannot_be_set_before_now
    errors.add(:deadline, I18n.t('errors.messages.task.deadline.before_date')) if deadline < Time.current.beginning_of_day
  end

  def image_type
    if image.attached?
      errors.add(:image, I18n.t('errors.messages.task.image.different_type', locale: :ja)) unless image.content_type.in?(%("image/jpeg image/png"))
    end
  end
end
