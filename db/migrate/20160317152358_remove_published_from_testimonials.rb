class RemovePublishedFromTestimonials < ActiveRecord::Migration
  def change
    remove_column :testimonials, :published, :date
  end
end
