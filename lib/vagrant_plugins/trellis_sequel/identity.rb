# frozen_string_literal: true

module VagrantPlugins
  module TrellisSequel
    module Identity
      def self.name
        'vagrant-trellis-sequel'
      end

      def self.version
        '0.2.2'
      end

      def self.description
        'Open Trellis databases in Sequel Pro with a single command'
      end

      def self.summary
        description
      end
    end
  end
end
