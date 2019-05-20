# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    description { 'RSpec & Capybara & FactoryBot を準備する' }
    deadline { Time.zone.now }
    state { '着手中' }
    association :user, factory: :admin_user
  end
end
