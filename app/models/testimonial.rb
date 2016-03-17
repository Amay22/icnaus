class Testimonial < ActiveRecord::Base
  belongs_to :user

  # Ensure that a user_id is present
  validates :user_id, presence: true

  # Ensure a title exists
  validates :title, presence: true
end
