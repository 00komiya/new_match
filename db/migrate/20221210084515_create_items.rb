class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :shop_name, null: false
      t.text :introduction, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
