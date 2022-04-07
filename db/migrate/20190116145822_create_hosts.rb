class CreateHosts < ActiveRecord::Migration[5.2]
  def change
    create_table :hosts do |t|
      t.string :name,         unique: true
      t.string :ip_address,   unique: true
      t.string :port,         default: 22

      t.timestamps
    end
  end
end
