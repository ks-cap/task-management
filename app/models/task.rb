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

  def self.csv_attributes
    ["name", "description", "deadline", "state", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      # allメソッドで全タスクを取得し１レコードごとにCSVの１行を出力するその際は属性ごとにTaskオブジェクトから属性値を取得しcsvに与えている。
      all.each do |task|
        csv << csv_attributes.map{ |attr| task.send(attr) }
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
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
