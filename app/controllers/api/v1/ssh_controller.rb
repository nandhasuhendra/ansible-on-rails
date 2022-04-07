class Api::V1::SshController < ApplicationController
  before_action :set_ssh_params

  def default
    @ssh = @output.default_user

    if @ssh[:status] == 'Success'
      render_json({ data: [@ssh[:host], @ssh[:status]]})
    else
      render_json({ data: [@ssh[:host], @ssh[:status]]}, :unprocessable_entity)
    end
  end

  private
    def set_params
      senitizer(params.require(:ssh).permit(:user, :password, :sudo_pass, :ip_address, :port, :file_name))
    end

    def set_ssh_params
      @output = SSH::Command.new(
        set_params[:user],
        set_params[:password],
        set_params[:sudo_pass],
        set_params[:ip_address],
        set_params[:port],
        set_params[:file_name]
      )
    end
end
