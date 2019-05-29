# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    association :user, factory: :user

    name { 'Task title' }
    description { 'Task description' }
    startline { Time.current }
    deadline { Time.current.since(1.day) }
    state { 0 }
  end
end
