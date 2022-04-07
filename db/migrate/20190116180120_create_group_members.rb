class CreateGroupMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_members do |t|
      t.string :build_status
      t.string :ping_status
      t.references :host, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
