json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :description
  json.start task.created_at
  json.end task.deadline
  json.url calendars_url(task, format: :html)
end
