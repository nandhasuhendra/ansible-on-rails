class CustomLogger < Logger
  def self.log_file(file_name)
    logfile = File.open(Dir.pwd + '/log/' + file_name + '.log', 'a')
    logfile.sync = true

    self.new(logfile)
  end

  def format_message(severity, timestamp, progname, msg)
    "%s, [%s] %-5.5s -- : %s\n" % [severity.first, timestamp, severity, msg]
  end
end
