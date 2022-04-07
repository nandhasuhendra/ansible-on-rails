class CreateCredentials < ActiveRecord::Migration[5.2]
  def change
    create_table :credentials do |t|
      t.string :name,     unique: true
      t.string :key_type, default: "RSA"
      t.string :file_name

      t.timestamps
    end
  end
end
