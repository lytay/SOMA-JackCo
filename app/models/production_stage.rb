class ProductionStage < ActiveRecord::Base
  include UuidHelper

  belongs_to :phase, foreign_key: :phase_id

  has_many :statuses

  validates :name, length: { maximum: 50 }, presence: true
  validates :phase_id, length: { maximum: 36 }, presence: true

  scope :find_by_production_stage_name, -> name { where("name like ?", "%#{name}%") }

end
