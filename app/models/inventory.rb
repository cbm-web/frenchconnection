class Inventory < ActiveRecord::Base
  has_and_belongs_to_many :certificates
end
