# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    association :user, factory: :user

    name { 'Task title' }
    description { 'Task description' }
    startline { Time.current - Random.new.rand((24*30)*60*60) }
    deadline { Time.current + Random.new.rand((24*30)*60*60) }
    state { 0 }
  end
end
