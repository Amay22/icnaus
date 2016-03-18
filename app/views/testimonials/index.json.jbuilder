json.array!(@testimonials) do |testimonial|
  json.extract! testimonial, :id, :testimonial, :title, :user_name, :created_at
  json.url testimonial_url(testimonial, format: :json)
end
