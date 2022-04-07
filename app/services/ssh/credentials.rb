module SSH
  class Credentials
    PATH = Dir.pwd + "/storage/credentials/"

    def initialize(params = {})
      @log        = CustomLogger.log_file('ssh_' + Rails.env)
      @name       = params[:name]
      @key_type   = params[:key_type]
      @passphrase = params[:passphrase]

      @key              = nil
      @private_key      = nil
      @public_key       = nil
      @credential_files = nil
    end

    def generate
      begin
        generate_rsa_key    if @key_type == "RSA"
        generate_dsa_key    if @key_type == "DSA"
        generate_secure_key if @passphrase.present?

        key_generator if @key.present?
      rescue => exception
        @log.fatal(exception)
        false
      end
    end

    def delete(file_name)
      Dir.glob(PATH + file_name + '.*').each do |file| 
        File.delete(file) if File.exist? (file)
      end
    end

    private
      def generate_secure_key
        @cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      end

      def generate_rsa_key
        @key = OpenSSL::PKey::RSA.new(2048)
      end

      def generate_dsa_key
        @key = OpenSSL::PKey::DSA.new(2048)
      end

      def key_generator
        if @cipher.present?
          @private_key = @key.export @cipher, @passphrase
        else
          @private_key = @key.to_pem
        end

        @public_key  = "#{@key.ssh_type} #{[@key.to_blob].pack('m0')}"

        created_files
      end

      def created_files
        @name = @name.gsub(' ', '_')
        delete(@name)

        open(PATH + @name + '.pem', 'w') do |file|
          file.write @private_key

          File.chmod(0400, PATH + @name + '.pem')
        end

        open(PATH + @name + '.pem.pub', 'w') do |file|
          file.write @public_key
        end

        @credential_files = @name
      end
  end
end
