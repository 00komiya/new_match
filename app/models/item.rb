class Item < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :item_comments, dependent: :destroy
  has_many :item_tags, dependent: :destroy
  has_many :tags, through: :item_tags
  has_many :notifications, dependent: :destroy

  has_one_attached :image

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}

  def get_image
    (image.attached?) ? image : 'no_image.jpg'
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

  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and item_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
     notification = current_user.active_notifications.new(
      item_id: id,
      visited_id: user_id,
      action: 'like'
    )
    # 自分の投稿に対するいいねは、通知済みとなる
    if notification.visitor_id == notification.visited_id
     notification.checked = true
    end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, item_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = ItemComment.select(:user_id).where(item_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, item_comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, item_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, item_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      item_id: id,
      item_comment_id: item_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
