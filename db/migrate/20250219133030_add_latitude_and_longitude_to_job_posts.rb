class AddLatitudeAndLongitudeToJobPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :job_posts, :latitude, :float
    add_column :job_posts, :longitude, :float
  end
end
