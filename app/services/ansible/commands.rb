module Ansible
  class Commands
    def initialize(params)
      @log   = CustomLogger.log_file('ansible_' + Rails.env)
      @path  = params[:file_path]
      set_vars(params)
    end

    def run_ping
      @file = Dir.pwd + "/storage/ansible/" + @path + "/" + @name + ".yaml"

      @command = "ansible -i %s -m ping %s" % [@file, @name]

      @log.info(run_command)
      run_command
    end

    def run_task
      @file  = Dir.pwd + "/storage/ansible/task/" + @name + ".yaml"
      @group = Dir.pwd + "/storage/ansible/group/" + @group + ".yaml"

      @command = "ansible-playbook -i %s %s" % [@group, @file]

      @log.info(run_command)
      run_command
    end

    private
      def set_vars(params)
        @name  = params[:name].gsub(' ', '_') unless params[:name].nil?
        @group = params[:group].gsub(' ', '_') unless params[:group].nil?
      end

      def run_command
        IO.popen(@command) do |output|
          return output.read
        end
      end
  end
end
