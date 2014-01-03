class CreateBlogrPosts < ActiveRecord::Migration
  def change
    create_table :blogr_posts do |t|
      t.string :title
      t.string :author
      t.string :body

      t.timestamps
    end
  end
end
