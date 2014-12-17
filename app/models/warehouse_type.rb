class WarehouseType < ActiveRecord::Base
  include UuidHelper
  # resourcify
  has_one :warehouse
  
  validates :name, length: { maximum: 50 }, presence: true

  scope :find_by_name, -> name { where("name like ?", "%#{name}%") }
end