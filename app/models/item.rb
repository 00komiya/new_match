class Item < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :item_comments, dependent: :destroy
  has_one_attached :image

   scope :latest, -> {order(created_at: :desc)}
   scope :old, -> {order(created_at: :asc)}

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/No_image.jpeg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def self.search_for(content, method)
    if method == "perfect"
      Item.where("name = ? OR introduction = ?", content, content)
    else
      Item.where('name LIKE ? OR introduction LIKE ? ', '%'+content+'%','%'+content+'%')
    end
  end
end
