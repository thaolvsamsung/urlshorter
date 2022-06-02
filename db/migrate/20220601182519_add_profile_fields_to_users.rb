class AddProfileFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    # add_index :users, :username, unique: true
    add_column :users, :api_token, :string
  end
end
