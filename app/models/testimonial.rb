class Testimonial < ActiveRecord::Base
  belongs_to :user

  # Ensure that a user_id is present
  validates :user_id, presence: true

  #Ensure a title has at least 1 characters
  validates :title, presence: true, length: { minimum: 1 }
end
