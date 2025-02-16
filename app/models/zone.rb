class Zone < ActiveRecord::Base
  include UuidHelper
  
  has_many :areas, foreign_key: :zone_id, dependent: :destroy
  has_many :blocks, through: :areas
  has_many :input_tasks, foreign_key: :zone_id
  has_many :output_tasks, foreign_key: :zone_id
  has_many :plan_zones, foreign_key: :zone_id
  belongs_to :farm, foreign_key: :farm_id

  validates :name, presence: true
end
