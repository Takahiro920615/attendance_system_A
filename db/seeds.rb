# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: "クウガ",
             email: "kuga@email.com",
             password: "kuga2000",
             password_confirmation: "kuga2000",
             admin: true)

60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
               

Base.create!(base_no: "#{n+1}",
             base_name: "拠点#{n+1}",
             attendance_type: "出勤")
end