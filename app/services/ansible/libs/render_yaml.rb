module Ansible
  module Libs
    class RenderYaml
      def initialize(resource)
        @resource = resource
      end

      def from_host
        @method_name = __method__.to_s.split('_')
        @file        = Dir.pwd + "/storage/credentials/default.pem"
        @erb_file    = Dir.pwd + "/app/services/ansible/templates/hosts.yaml.erb"

        renderer
      end

      def from_group
        @method_name = __method__.to_s.split('_')
        @file        = Dir.pwd + "/storage/credentials/" + @resource.credential.file_name + ".pem" unless @resource.credential.nil?
        @erb_file    = Dir.pwd + "/app/services/ansible/templates/groups.yaml.erb"

        renderer
      end

      def from_task
        @method_name = __method__.to_s.split('_')
        @erb_file    = Dir.pwd + "/app/services/ansible/templates/playbook.yaml.erb"

        renderer
      end

      private
        def renderer
          @yaml_format = YAML.load(ERB.new(File.read(@erb_file)).result(binding)).to_yaml

          create_file
        end

        def create_file
          unless @method_name[1].eql? "task"
            File.write(
              Dir.pwd + "/storage/ansible/#{@method_name[1]}/" + @resource.name.gsub(' ','_') + ".yaml", 
              @yaml_format, 
              mode: 'w'
            )
          else
            File.write(
              Dir.pwd + "/storage/ansible/#{@method_name[1]}/" + @resource.task.name.gsub(' ','_') + ".yaml", 
              @yaml_format, 
              mode: 'w'
            )
          end
        end
    end
  end
end
