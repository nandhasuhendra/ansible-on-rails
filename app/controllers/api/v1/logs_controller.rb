class Api::V1::LogsController < ApplicationController
  before_action :cat_log, only: [:log_rails, :log_ssh, :log_ansible]

  def log_rails
    render_json({ data: @rails })
  end

  def log_ssh
    render_json({ data: @ssh })
  end

  def log_ansible
    render_json({ data: @ansible })
  end

  private
    def checking_file(file_name = "")
      Dir.glob(Dir.pwd + "/log/" + file_name + Rails.env + ".log").each do |file_path|
        return nil unless File.exist? file_path

        return File.readlines(file_path).last(300)
      end
    end

    def cat_log
      @rails    = checking_file
      @ssh      = checking_file("ssh_")
      @ansible  = checking_file("ansible_")
    end
end
