class Item < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :item_comments, dependent: :destroy
  has_many :item_tags, dependent: :destroy
  has_many :tags, through: :item_tags

  has_one_attached :image

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}

  def get_image
    (image.attached?) ? image : 'no_image.jpeg'
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

  def tag_name
    self.tags.map{|tag| "#{tag.name}"}.join(',')
  end

  def save_tags(saveitem_tags)
    # 現在のユーザーの持っているskillを引っ張ってきている
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 今itemが持っているタグと今回保存されたものの差をすでにあるタグとする。古いタグは消す。
    old_tags = current_tags - saveitem_tags
    # 今回保存されたものと現在の差を新しいタグとする。新しいタグは保存
    new_tags = saveitem_tags - current_tags

    # Destroy old taggings:
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end

    # Create new taggings:
    new_tags.each do |new_name|
      item_tag = Tag.find_or_create_by(name:new_name)
      # 配列に保存
      self.tags << item_tag
    end
  end

end
