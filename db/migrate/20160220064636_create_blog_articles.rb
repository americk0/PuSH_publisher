class CreateBlogArticles < ActiveRecord::Migration
  def change
    create_table :blog_articles do |t|
      t.string :title
      t.string :author
      t.text :text

      t.timestamps null: false
    end
  end
end
