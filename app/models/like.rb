class Like < ApplicationRecord

  belongs_to :user
  belongs_to :item

  # ひとりのユーザー(user_id)がひとつのbook_idに対して1いいね
  validates_uniqueness_of :item_id, scope: :user_id

end
