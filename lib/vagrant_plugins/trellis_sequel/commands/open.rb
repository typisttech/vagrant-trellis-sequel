# frozen_string_literal: true

require 'erb'
require 'ostruct'
require 'vagrant_plugins/trellis_sequel/vault'

module VagrantPlugins
  module TrellisSequel
    module Commands
      class Open < Vagrant.plugin('2', :command)
        # rubocop:disable Metrics/MethodLength
        def execute
          options = {}
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant trellis-sequel open [options] [vm-id]'
            o.separator ''

            o.on('--site [site]', String, 'Site whose database going to be opened.') do |site|
              options[:site] = site
            end

            o.on('--vault-password-file [VAULT_PASSWORD_FILE]', String, 'Vault password file.') do |vault_password_file|
              options[:vault_password_file] = vault_password_file
            end

            o.on('--vault-pass [VAULT_PASS]', String, 'Vault password.') do |vault_password|
              options[:vault_password] = vault_password
            end

            o.on('-h', '--help', 'Print this help') do
              @env.ui.info(opts)
              exit
            end
          end
          argv = parse_options(opts)

          with_target_vms(argv) do |machine|
            # Collect SSL data
            ssh_info = machine.ssh_info
            raise Vagrant::Errors::SSHNotReady if ssh_info.nil?

            options[:vault_password] ||= vault_password_from(path: options[:vault_password_file], machine: machine)

            # Collect database data
            vault_path = File.join(machine.env.root_path, 'group_vars/development/vault.yml')
            vault = Vault.new(path: vault_path, password: options[:vault_password])

            data = {
              database: vault.database_for(site: options[:site]),
              ssh: {
                host: ssh_info[:host],
                port: ssh_info[:port],
                user: ssh_info[:username],
                private_key_path: ssh_info[:private_key_path]
              }
            }

            # Output template
            content = template.result(OpenStruct.new(data).instance_eval { binding })

            # Write it to the file
            path = File.join(@env.tmp_path, "#{data[:database][:name]}.spf")
            file = File.open(path, 'w')
            file.write(content)
            file.close

            # And, open it
            system("open \"#{path}\"")
          end

          # Always exit with success
          0
        end
        # rubocop:enable Metrics/MethodLength

        private

        def vault_password_from(path: nil, machine: nil)
          path ||= File.join(machine.env.root_path, '.vault_pass')
          File.read(path).chomp
        end

        def template
          path = File.join(File.dirname(__FILE__), '/..', 'template.spf')
          ERB.new(File.read(path), nil, '%<>')
        end
      end
    end
  end
end
