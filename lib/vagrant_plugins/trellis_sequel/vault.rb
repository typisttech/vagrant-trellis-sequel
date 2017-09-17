# frozen_string_literal: true

require 'ansible/vault'

module VagrantPlugins
  module TrellisSequel
    class Vault
      def initialize(path:, password:)
        @path = path
        @password = password
      end

      def database_for(site: nil)
        site ||= first_wordpress_site

        unless password_exist_for? site
          raise Vagrant::Errors::CLIInvalidOptions.new help: "DB password not found for #{site}"
        end

        {
          name: db_name_for(site: site),
          user: db_user_for(site: site),
          password: db_password_for(site: site)
        }
      end

      private

      def first_wordpress_site
        wordpress_sites&.keys&.first
      end

      def password_exist_for?(site)
        !db_password_for(site: site).nil?
      end

      def db_name_for(site:)
        underscore(site) + '_development'
      end

      def db_user_for(site:)
        underscore(site)
      end

      def db_password_for(site:)
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
        word = domain.downcase
        word.tr!('.', '_')
      end
    end
  end
end
