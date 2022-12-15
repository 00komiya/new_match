class Tag < ApplicationRecord
  has_many :item_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :items, through: :item_tags

  scope :merge_books, -> (tags){ }

  def self.search_items_for(content, method)
    if method == 'perfect'
      tags = Tag.where(name: content)
    else
      tags = Tag.where('name LIKE ?', '%'+content+'%')
    end

  return tags.inject(init = []) {|result, tag| result + tag.items}

  end
end
