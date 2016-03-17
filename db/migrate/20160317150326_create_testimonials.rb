class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.text :testimonial
      t.date :published
      t.string :title
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
