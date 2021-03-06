require 'winrm'
require 'winrm-elevated'

# kpn_winrm
module KpnWinrm
  def self.winrm_command(host, command, opts = {})
    # Get parameters
    puts host
    user = host[:ssh][:user]
    pass = host[:ssh][:password]
    hostname = host.to_s
    endpoint = 'http://' + hostname + ':5985/wsman'
    acceptable_exit_codes = if opts.key?(:acceptable_exit_codes) && !opts[:acceptable_exit_codes].nil?
                              opts[:acceptable_exit_codes]
                            else
                              opts[:acceptable_exit_codes] = [0]
                            end

    run_as_cmd = false
    if opts.key?(:run_as_cmd) && !opts[:acceptable_exit_codes].nil?
      run_as_cmd = true
    end

    # Setup winrm
    opts = {
      user: user,
      password: pass,
      endpoint: endpoint,
      operation_timeout: 300,
    }
    host.logger.debug 'Trying to connect to windows host'
    p opts.inspect
    winrm = WinRM::Connection.new opts

    # Debugging
    host.logger.debug "Running command '#{command}' via winrm"
    # Execute command via winrm
    if run_as_cmd
      winrm.shell(:cmd) do |shell|
        @result = shell.run(command) do |stdout, stderr|
          host.logger.debug stdout
          host.logger.debug stderr
        end
      end
    else
      winrm.shell(:elevated) do |shell|
        @result = shell.run(command) do |stdout, stderr|
          host.logger.debug stdout
          host.logger.debug stderr
        end
      end
    end

    # Debugging
    host.logger.debug "winrm - stdout  :#{stdout}"
    host.logger.debug "winrm - stderr  :#{stderr}"
    host.logger.debug "winrm - exitcode:#{@result.exitcode}"

    unless acceptable_exit_codes.include?(@result.exitcode)
      raise StandardError, "Command '#{command}' failed with unacceptable exit code:#{@result.exitcode} on host '#{hostname}'\n" \
                          "Stdout:#{@result.stdout}\n" \
                          "Stderr:#{@result.stderr}\n"
    end

    # Return flat hash with stdout, stderr and the exitcode
    { stdout: @result.stdout,
      stderr: @result.stderr,
      exitcode: @result.exitcode }
  end

  def self.apply_manifest_on_winrm(host, manifest, opts = {})
    if [opts[:catch_changes], opts[:catch_failures], opts[:expect_failures], opts[:expect_changes]].compact.length > 1
      raise StandardError, 'only one of :catch_changes, :catch_failures, :expect_failures and :expect_changes should be set'
    end

    acceptedexitcodes = [0]

    if opts[:catch_changes]
      acceptedexitcodes = [0]
    end

    if opts[:catch_failures]
      acceptedexitcodes = [0, 2]
    end

    if opts[:expect_failures]
      acceptedexitcodes = [1, 4, 6]
    end

    if opts[:expect_changes]
      acceptedexitcodes = [2]
    end

    file_path = host.tmpfile('apply_manifest.pp')
    create_remote_file(host, file_path, manifest + "\n")

    winrm_command(host, 'puppet apply --detailed-exitcodes ' + file_path + '; exit $lastexitcode', acceptable_exit_codes: acceptedexitcodes)
  end
end
