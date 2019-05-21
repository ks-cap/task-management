# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'test_user' }
    sequence(:email) { |n| "test_email_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
  end
end
