class Item < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :item_comments, dependent: :destroy
end
