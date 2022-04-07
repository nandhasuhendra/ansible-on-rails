module SSH
  class Command
    def initialize(user, password, sudo_pass, ip_address, port, file_name = nil)
      @log        = CustomLogger.log_file('ssh_' + Rails.env)
      @user       = user
      @password   = password
      @sudo_pass  = sudo_pass
      @ip_address = ip_address
      @port       = port
      @file_name  = file_name

      @def_user   = "ansible"
      @def_passwd = "123123"
      @commands   = []
    end
    
    def copy_id
      @file_name = File.read(Dir.pwd + "/storage/credentials/" + @file_name + ".pem.pub").squish

      @commands = [
        "mkdir -m 700 -p ~/.ssh",
        "echo '#{@file_name}' >> ~/.ssh/authorized_keys",
        "chmod 600 ~/.ssh/authorized_keys"
      ]

      system("ssh-keyscan #{@ip_address} >> ~/.ssh/known_hosts")

      @log.info(executes)
      executes
    end

    def remove_id
      @file_name = File.read(Dir.pwd + "/storage/credentials/" + @file_name + ".pem.pub").squish

      @commands = [
        "grep -v '#{@file_name}' ~/.ssh/authorized_keys > ~/.ssh/temp",
        "mv ~/.ssh/temp ~/.ssh/authorized_keys"
        ]

      @log.info(executes)
      executes
    end

    def default_user
      @commands = [
        "sudo useradd -m -G sudo -s /bin/bash #{@def_user}",
        "sudo passwd #{@def_user}",
        "sudo sh -c 'echo \"#{@def_user} ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers'"
      ]

      @log.info(executes)
      return executes unless executes[:status] == 'Success'

      @user      = @def_user
      @password  = @def_passwd
      @file_name = "default"

      return copy_id
    end


    private
      def executes
        result = ''

        Net::SSH.start(@ip_address, @user, port: @port || 22, password: @password, :timeout => 5, :non_interactive => true, verbose: :debug, logger: @log) do |ssh|
          @commands.each do |command|
            Timeout.timeout 15 do
              ssh.open_channel do |channel|
                channel.request_pty do |ch, success|
                  raise "could not request pty" unless success

                  ch.exec(command)

                  ch.on_data do |_c, data|
                    _c.send_data "#{@sudo_pass}\n" if data.include? '[sudo]'
                    _c.send_data "#{@def_passwd}\n" if data.include? 'password'

                    result << data.to_s

                    return { host: @ip_address, status: result[0] } if data.include? "Sorry"
                  end
                end
                channel.wait
              end
              ssh.loop
            end
          end
        end

        return { host: @ip_address, status: "Success" }
      rescue Timeout::Error
        return { host: @ip_address, status: "Request Timeout" }
      rescue Errno::ENETUNREACH
        return { host: @ip_address, status: "Network Unreachable" }
      rescue Errno::EHOSTUNREACH
        return { host: @ip_address, status: "Host Unreachable" }
      rescue Errno::ECONNREFUSED
        return { host: @ip_address, status: "Connection Refused" }
      rescue Net::SSH::ConnectionTimeout
        return { host: @ip_address, status: "Connection Timeout" }
      rescue Net::SSH::AuthenticationFailed
        return { host: @ip_address, status: "Authentication Failed" }
      end
  end
end
