# frozen_string_literal: true

require 'ansible/vault'

module VagrantPlugins
  module TrellisSequel
    class Vault
      def self.build(machine_root_path:, vault_pass: nil, vault_password_file: nil, **_)
        vault_path = File.join(machine_root_path, 'group_vars', 'development', 'vault.yml')

        if ::Ansible::Vault.encrypted?(vault_path)
          vault_pass ||= VaultPass.read_from_file(
            file_path: vault_password_file,
            machine_root_path: machine_root_path
          )
        end

        Vault.new(path: vault_path, password: vault_pass)
      end

      def initialize(path:, password:)
        @path = path
        @password = password
      end

      def database_for(site: nil, **_)
        site ||= first_wordpress_site

        raise "DB password not found for #{site}" unless password_exist_for?(site)

        {
          name: db_name_for(site),
          user: db_user_for(site),
          password: db_password_for(site)
        }
      end

      private

      def first_wordpress_site
        wordpress_sites&.keys&.first
      end

      def password_exist_for?(site)
        !db_password_for(site).nil?
      end

      def db_name_for(site)
        underscore(site) + '_development'
      end

      def db_user_for(site)
        underscore(site)
      end

      def db_password_for(site)
        content.dig('vault_wordpress_sites', site, 'env', 'db_password')
      end

      def wordpress_sites
        content.dig('vault_wordpress_sites')
      end

      def content
        @content ||= YAML.safe_load(content_raw)
      end

      def content_raw
        @content_raw ||= ::Ansible::Vault.read(path: @path, password: @password, allow_blank_password: true)
      end

      def underscore(domain)
        domain.downcase
              .tr('.', '_')
      end
    end
  end
end
