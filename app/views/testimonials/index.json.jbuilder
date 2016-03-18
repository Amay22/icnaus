json.array!(@testimonials) do |testimonial|
  json.extract! testimonial, :id, :testimonial, :title, :user_name
  json.url testimonial_url(testimonial, format: :json)
end
