json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :description
  json.title task[:name]
  json.start task[:created_at]
  json.end task[:deadline]
  json.url tasks_url(task, format: :html)
end
