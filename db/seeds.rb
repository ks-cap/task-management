# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.name = 'admin'
  user.email = 'admin@example.com'
  user.admin = true
  user.password = 'password'
  user.password_confirmation = 'password'
end

3.times do |n|
  FactoryBot.create(:group, name: "test_group_#{n}")
end

5.times do |n|
  case n % 3
  when 0 then
    FactoryBot.create(:user, name: "test_user_#{n}", email: "test_email_#{n}@example.com", group: Group.first)
  when 1 then
    FactoryBot.create(:user, name: "test_user_#{n}", email: "test_email_#{n}@example.com", group: Group.second)
  when 2 then
    FactoryBot.create(:user, name: "test_user_#{n}", email: "test_email_#{n}@example.com", group: Group.third)
  end
end

50.times do |n|
  case n % 5
  when 0 then
    FactoryBot.create(:task, state: rand(3), name: "タイトル_#{n}", user: User.first, owner: User.first, tag_list: ["rails","php","js","python"])
  when 1 then
    FactoryBot.create(:task, state: rand(3), name: "タイトル_#{n}", user: User.second, owner: User.fourth, tag_list: ["swift","python"])
  when 2 then
    FactoryBot.create(:task, state: rand(3), name: "タイトル_#{n}", user: User.third, owner: User.fifth, tag_list: ["js"])
  when 3 then
    FactoryBot.create(:task, state: rand(3), name: "タイトル_#{n}", user: User.second, owner: User.second, tag_list: [""])
  when 4 then
    FactoryBot.create(:task, state: rand(3), name: "タイトル_#{n}", user: User.third, owner: User.third, tag_list: ["swift"])
  end
end
