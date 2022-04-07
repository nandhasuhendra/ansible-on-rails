class Api::V1::AnsiblesController < ApplicationController
  def ping
    set_ping

    render_json({ data: @ansible })
  end

  def task
    set_task

    render_json({ data: @ansible })
  end

  private
    def set_params
      senitizer(params.require(:ansible).permit(:job_id, :group_id, :name, :file_path))
    end

    def checking_file
      File.exist? (Dir.pwd + '/storage/ansible/' + set_params[:file_path] + '/' + set_params[:name].gsub(' ', '_') + '.yaml')
    end

    def set_ping
      @group   = Group.includes(:hosts).find_by_id(set_params[:group_id])
      @ansible = []

      if checking_file
        result = Ansible::Commands.new(set_params).run_ping

        unless result.empty?
          specific_result = result.scan(/\d[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}...\b[[:upper:]]+\b./).map { |r| r.split(' | ') }

          specific_result.each do |ip, status|
            status = status.capitalize!

            @ansible << { host: ip, status: status, messages: result.squish.gsub('\r\n', '') }

            unless @group.nil?
              @group.hosts.each do |host|
                @group.group_members.where(host_id: host.id).update(ping_status: status) if host.ip_address == ip
              end
            end
          end
        end
      else
        @ansible << { host: set_params[:name], status: "Setup first before testing ping" }
      end
    end

    def set_task
      @job = Job.includes(:task, :group).find_by_id(set_params[:job_id])
      @ansible = []

      if checking_file
        result = Ansible::Commands.new(
          file_path: @job.task.task_file,
          group: @job.group.name,
          name: @job.task.name
        ).run_task

        unless result.empty?
          specific_result = result.scan(/\d[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\s*..ok=\d\s*changed=\d\s*unreachable=\d\s*failed=\d/).map { |r| r.split(/\s\W*/) }

          specific_result.each do |details|
            @ansible << { ip_address: details[0], ok: details[1].scan(/\d/).join, changed: details[2].scan(/\d/).join, unreachable: details[3].scan(/\d/).join, failed: details[4].scan(/\d/).join}
          end
        end
      else
        @ansible << { host: set_params[:name], status: "Setup first before testing ping" }
      end

      @job.update_attributes(deployed: Time.now)
    end
end
