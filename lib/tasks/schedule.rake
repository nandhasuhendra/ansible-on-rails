namespace :schedule do
  desc "Run Schedule"
  task run_schedule: :environment do
    jobs = Job.includes(:task, :group).all
    time = Time.now.strftime("%Y-%m-%d %H:%M")

    jobs.each do |job|
      if time == job.scheduler.strftime("%Y-%m-%d %H:%M")
        @job = Job.find_by_id(job.id)

        puts "Last deployed at #{@job.deployed}"

        if checking_file(job.task.name)
          result = Ansible::Commands.new(
            file_path: 'task',
            group: @job.group.name,
            name: @job.task.name
          ).run_task

          unless result.empty?
            specific_result = result.scan(/\d[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\s*..ok=\d\s*changed=\d\s*unreachable=\d\s*failed=\d/).map { |r| r.split(/\s\W*/) }

            specific_result.each do |details|
              puts "Status : #{@ansible = { ip_address: details[0], ok: details[1].scan(/\d/).join, changed: details[2].scan(/\d/).join, unreachable: details[3].scan(/\d/).join, failed: details[4].scan(/\d/).join}}"
            end
          end
        else
          puts "Status: #{@ansible = { host: @job.task.name, status: "Setup first before testing ping" }}"
        end

        @job.update_attributes(deployed: Time.now)

        puts "Deployed at #{@job.deployed}"
      end
    end
  end
end

def checking_file(name)
  File.exist? (Dir.pwd + '/storage/ansible/task/' + name.gsub(' ', '_') + '.yaml')
end
