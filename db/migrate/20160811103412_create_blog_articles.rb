class CreateBlogArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :blog_articles do |t|
      t.string :title
      t.string :author
      t.text :content
      t.boolean :favorite, default: false

      t.timestamps
    end
  end
end
