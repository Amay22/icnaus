class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.text :testimonial
      t.string :title,              null: false, default: ""
      t.string :user_name,          null: false, default: ""
      t.integer :user_id,           null: false

      t.timestamps null: false
    end
  end
end
