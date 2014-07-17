class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :user_name
      t.string :image_url
      t.string :small_image_url
      t.string :token
      t.string :token_secret
      t.string :user_id
      t.string :link
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
