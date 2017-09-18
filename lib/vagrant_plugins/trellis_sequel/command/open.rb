# frozen_string_literal: true

require 'vagrant_plugins/trellis_sequel/spf'
require 'vagrant_plugins/trellis_sequel/vault'
require 'vagrant_plugins/trellis_sequel/vault_pass'

module VagrantPlugins
  module TrellisSequel
    module Command
      class Open < Vagrant.plugin('2', :command)
        def execute
          options, argv = parse_options!

          with_target_vms(argv) do |machine|
            raise Vagrant::Errors::SSHNotReady unless machine.communicate.ready?

            Spf.create_and_open(
              data: {
                database: database_for(machine_root_path: machine.env.root_path, **options),
                ssh: ssh_for(machine)
              },
              path: machine.env.tmp_path
            )
          end

          # Always exit with success
          0
        end

        private

        # rubocop:disable Metrics/MethodLength
        def parse_options!
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

            o.on('--vault-pass [VAULT_PASS]', String, 'Vault password.') do |vault_pass|
              options[:vault_pass] = vault_pass
            end

            o.on('-h', '--help', 'Print this help') do
              @env.ui.info(opts)
              exit
            end
          end
          [options, parse_options(opts)]
        end
        # rubocop:enable Metrics/MethodLength

        def database_for(args)
          Vault.build(**args)
               .database_for(**args)
        end

        def ssh_for(machine)
          machine.ssh_info.select do |key, _value|
            %i[host port username private_key_path].include?(key)
          end
        end
      end
    end
  end
end
