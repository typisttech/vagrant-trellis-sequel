# frozen_string_literal: true

require 'ansible/vault'

module VagrantPlugins
  module TrellisSequel
    class Vault
      def initialize(path:, password: 'nope')
        @path = path
        @password = password
      end

      def database_for(site: nil)
        site ||= wordpress_sites&.keys&.first

        unless password_exist_for? site
          raise Vagrant::Errors::CLIInvalidOptions.new help: "DB password not found for #{site}"
        end

        {
          "name": name_for(site: site),
          "user": user_for(site: site),
          "password": password_for(site: site)
        }
      end

      private

      def password_exist_for?(site)
        !password_for(site: site).nil?
      end

      def name_for(site:)
        underscore(site) + '_development'
      end

      def user_for(site:)
        underscore(site)
      end

      def password_for(site:)
        content.dig('vault_wordpress_sites', site, 'env', 'db_password')
      end

      def wordpress_sites
        content.dig('vault_wordpress_sites')
      end

      def content
        @content ||= YAML.safe_load(content_raw)
      end

      def content_raw
        @content_raw ||= ::Ansible::Vault.read(path: @path, password: @password)
      end

      def underscore(domain)
        word = domain.downcase
        word.tr!('.', '_')
      end
    end
  end
end
