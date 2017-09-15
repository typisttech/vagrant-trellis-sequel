# frozen_string_literal: true

require "erb"
require "ostruct"
require "optparse"
require "vagrant"

module VagrantPlugins
  module TrellisSequel
    module Commands
      class Open < Vagrant.plugin("2", :command)
        def execute
          options = {}
          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant trellis-sequel open [options] [vm-id]"
            o.separator ""

            o.on("-u", "--user DB_USER", String, "Required. Database username.") do |user|
              options[:user] = user
            end

            o.on("-p", "--password DB_PASSWORD", String, "Required. Value of db_password from group_vars/development/vault.yml") do |password|
              options[:password] = password || "example_dbpassword"
            end

            o.on("-h", "--help", "Print this help") do
              @env.ui.info(opts)
              exit
            end
          end
          argv = parse_options(opts)

          # Check required options
          missing_required_options = [:user, :password].any? { |param| options[param].nil? }
          fail Vagrant::Errors::CLIInvalidOptions.new(help: "Missing required options.") if missing_required_options

          @env.ui.info("Generating SPF file...")

          # Load the SPF template
          template_path = File.join(File.dirname(__FILE__), "/..", "template.spf")
          template = ERB.new(File.read(template_path), nil, "%<>")

          with_target_vms(argv) do |machine|
           # Collect data
           ssh_info = machine.ssh_info
           raise Vagrant::Errors::SSHNotReady if ssh_info.nil?

           data = {
             "database" => {
               "name" => "#{options[:user]}_development",
              "user" => options[:user],
              "password" => options[:password],
            },
            "ssh" => {
              "host" => ssh_info[:host],
              "port" => ssh_info[:port],
              "user" => ssh_info[:username],
              "private_key_path" => ssh_info[:private_key_path],
            }
          }

           # Output template
           content = template.result OpenStruct.new(data).instance_eval { binding }

           # Write it to the file
           path = File.join(@env.tmp_path, "#{data["database"]["name"]}.spf")
           file = File.open(path, "w")
           file.write(content)
           file.close()

           # And, open it
           system("open \"#{path}\"")
         end

          # Always exit with success
          0
       end
      end
    end
  end
end
