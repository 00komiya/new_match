# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 管理者のメールアドレスの初期設定
Admin.create(
  email: "admin@admin",
  password: "adminadmin"
  )

users = User.create!(
  [
    {
      email: 'tanka@test.com',
      name: '田中',
      password:'tanakatanaka',
      introduction: 'よろしくお願いします',
      age: '20',
      sex: '男',
      address: '東京',
      profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("app/assets/images/pasta.jpg"), filename:"open.jpg")},
    {
      email: 'hanako@test.com',
      name: 'はなこ',
      password:'hanakohanako',
      introduction: 'スイーツ大好き！絡んでください',}
  ]
)

items = Item.create(
  [
    {
      name: 'カルボナーラ',
      shop_name: 'セブンイレブン',
      introduction: '温玉が二つになって新登場!!',
      user_id: users[0].id ,
      image: ActiveStorage::Blob.create_and_upload!(io: File.open("app/assets/images/pasta.jpg"), filename: 'default-image.jpg')},
    {
      name: 'マリトッツォ',
      shop_name: 'ローソン',
      introduction: 'コラボ品！食べた人感想教えてください！',
       user_id: users[1].id ,
      image: ActiveStorage::Blob.create_and_upload!(io: File.open("app/assets/images/sweets.jpg"), filename: 'default-image.jpg')}
  ]
)

  Tag.create(name: "お弁当")
  Tag.create(name: "おにぎり")
  Tag.create(name: "パン")
  Tag.create(name: "パスタ")
  Tag.create(name: "麺類")
  Tag.create(name: "ホットスナック")
  Tag.create(name: "スイーツ")
  Tag.create(name: "アイス")
  Tag.create(name: "お菓子")
  Tag.create(name: "ドリンク")
  Tag.create(name: "アルコール")
  Tag.create(name: "コラボ")
  Tag.create(name: "限定品")
