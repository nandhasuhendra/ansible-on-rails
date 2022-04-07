class AddScheduleToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :scheduler, :datetime
  end
end
