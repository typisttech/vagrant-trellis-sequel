# frozen_string_literal: true

module VagrantPlugins
  module TrellisSequel
    class VaultPass
      def self.read_from_file(args)
        path = candidates(**args).find do |p|
          File.file?(p)
        end

        if path.nil?
          raise "Couldn't determine vault password. I looked in:\r\n    * #{candidates(**args).join("\r\n    * ")}\r\n"
        end

        File.read(path).chomp
      end

      def self.candidates(file_path:, machine_root_path:)
        paths = []
        paths << file_path unless file_path.nil?
        paths << File.join(machine_root_path, file_path) unless file_path.nil? || machine_root_path.nil?
        paths << File.join(machine_root_path, '.vault_pass') unless machine_root_path.nil?
      end
    end
  end
end
