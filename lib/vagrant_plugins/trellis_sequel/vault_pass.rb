# frozen_string_literal: true

module VagrantPlugins
  module TrellisSequel
    class VaultPass
      def self.read_from_file(file_path:, machine_root_path:)
        paths = []
        paths << file_path unless file_path.nil?
        paths << File.join(machine_root_path, file_path) unless file_path.nil? || machine_root_path.nil?
        paths << File.join(machine_root_path, '.vault_pass') unless machine_root_path.nil?

        path = paths.find do |p|
          File.file?(p)
        end

        raise "Couldn't determine vault password. I looked in:\r\n    * #{paths.join("\r\n    * ")}\r\n" if path.nil?

        File.read(path).chomp
      end
    end
  end
end
