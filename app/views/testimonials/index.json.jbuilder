json.array!(@testimonials) do |testimonial|
  json.extract! testimonial, :id, :testimonial, :published, :title, :user_id
  json.url testimonial_url(testimonial, format: :json)
end
