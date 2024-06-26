class Category < ApplicationRecord
  has_many :products

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
    attachable.variant :medium, resize_to_limit: [250, 250]
  end
end
