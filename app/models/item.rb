class Item < ApplicationRecord
  validates :code, presence: true, length: { maximum: 255 }
  validates :name, presence: true, length: { maximum: 255 }
  validates :url, presence: true, length: { maximum: 255 }
  validates :image_url, presence: true, length: { maximum: 255 }
  
  has_many :wants
  has_many :want_users, through: :wants, class_name: 'User', source: :user
  
  has_many :havings, class_name: 'Have'
  has_many :having_users, through: :havings, class_name: 'User', source: :user
end
