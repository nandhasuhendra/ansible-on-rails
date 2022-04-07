class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username,         unique: true
      t.string :email,            unique: true
      t.string :password_digest
      t.string :token,            unique: true

      t.timestamps
    end
  end
end