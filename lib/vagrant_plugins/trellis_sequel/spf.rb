# frozen_string_literal: true

require 'erb'
require 'ostruct'

module VagrantPlugins
  module TrellisSequel
    class Spf
      def self.create_and_open(args)
        new(args).tap(&:write).open
      end

      def initialize(data:, path:)
        db_name = data.dig(:database, :name).to_s.gsub(/\s+/, '')
        raise 'You must provide data[:database][:name]' if db_name.empty?

        @data = data
        @path = File.join(path, "#{db_name}.spf")
      end

      def write
        File.open(@path, 'w') do |file|
          file.write(content)
        end
      end

      def open
        system("open \"#{@path}\"")
      end

      private

      def content
        template.result(OpenStruct.new(@data).instance_eval { binding })
      end

      def template
        ERB.new(File.read(template_path), nil, '%<>')
      end

      def template_path
        File.join(File.dirname(__FILE__), 'template.spf')
      end
    end
  end
end
