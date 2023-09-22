require 'faker'

namespace :db do
  desc 'Generate fake users'
  task generate_fake_users: :environment do
    num_users = 100 

    num_users.times do
      User.create!(
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.cell_phone,
        username: Faker::Internet.username,
        fullname: Faker::Name.name,
        password: Faker::Internet.password(min_length: 8)
      )
    end

    puts "#{num_users} fake users created."
  end
end
