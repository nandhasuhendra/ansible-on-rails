class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :name,         unique: true
      t.string :descriptions
      t.datetime :deployed
      t.references :group,    foreign_key: true
      t.references :task,     foreign_key: true

      t.timestamps
    end
  end
end
