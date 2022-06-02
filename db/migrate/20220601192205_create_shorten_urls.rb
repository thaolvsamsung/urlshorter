class CreateShortenUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :shorten_urls do |t|
      t.references :owner, polymorphic: true
      t.text :url, null: false
      t.string :unique_key, null: false
      t.integer :click_count, default: 0, null: false
      t.datetime :expires_at
      t.datetime :created_at
      t.datetime :updated_at
      t.string :category

      t.timestamps
    end
  end
end
