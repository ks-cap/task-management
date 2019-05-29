json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :description
  json.title task[:name]
  json.start task[:startline]
  json.end task[:deadline]
  json.url task_url(task, format: :html)
end
