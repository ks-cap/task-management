FactoryBot.define do
  factory :task do
    association :user, factory: :user

    name { 'Task title' }
    description { 'Task description' }
    deadline { Time.current.since(1.day) }
    state { Task.states[:未着手] }
  end
end
