class AddGoogleAuthFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :provider_uid, :string
    add_column :users, :nickname, :string
    add_column :users, :profile_image_url, :string
    add_column :users, :email_verified, :boolean, default: false, null: false
    add_column :users, :last_sign_in_at, :datetime

    add_index :users, %i[provider provider_uid], unique: true
    add_index :users, :nickname, unique: true
    add_index :users, :email, unique: true
  end
end
