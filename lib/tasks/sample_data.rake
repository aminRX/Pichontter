namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Amin Ogarrio",
                 email: "amin.ogarrio@gmail.com",
                 password: "cradle123",
                 password_confirmation: "cradle123")
    admin.toggle!(:admin)

    99.times do
      name  = Faker::Name.name
      email = Faker::Internet.email
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    user = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      user.each { |user| user.micropost.create!(content: content) }
    end
  end
end