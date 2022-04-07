# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

set :output, "#{Dir.pwd}/log/cron_log.log"
set :environment, 'development'

every 1.minute do
  command "cd #{Dir.pwd} && rvm use 2.5.1@ansible_on_rails && RAILS_ENV=development bundle exec rake schedule:run_schedule"
end

# Learn more: http://github.com/javan/whenever
