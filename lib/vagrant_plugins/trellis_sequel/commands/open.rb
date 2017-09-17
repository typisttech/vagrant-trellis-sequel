# frozen_string_literal: true

require 'ansible/vault'
require 'vagrant_plugins/trellis_sequel/spf'
require 'vagrant_plugins/trellis_sequel/vault'
require 'vagrant_plugins/trellis_sequel/vault_pass'

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

            o.on('--vault-pass [VAULT_PASS]', String, 'Vault password.') do |vault_pass|
              options[:vault_pass] = vault_pass
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

            # Collect database data
            vault_path = File.join(machine.env.root_path, 'group_vars/development/vault.yml')

            if ::Ansible::Vault.encrypted?(vault_path)
              options[:vault_pass] ||= VaultPass.read_from_file(
                file_path: options[:vault_password_file],
                machine_root_path: machine.env.root_path
              )
            end

            vault = Vault.new(path: vault_path, password: options[:vault_pass])

            data = {
              database: vault.database_for(site: options[:site]),
              ssh: {
                host: ssh_info[:host],
                port: ssh_info[:port],
                user: ssh_info[:username],
                private_key_path: ssh_info[:private_key_path]
              }
            }

            Spf.create_and_open(data: data, path: @env.tmp_path)
          end

          # Always exit with success
          0
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
