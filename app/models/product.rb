class Product < ApplicationRecord
  validates :name, :price, :code, presence: true
end
