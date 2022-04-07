class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name,         unique: true
      t.string :descriptions
      t.text :task
      t.string :task_file,    unique: true

      t.timestamps
    end
  end
end
