# frozen_string_literal: true

require 'optparse'

module VagrantPlugins
  module TrellisSequel
    module Commands
      class Root < Vagrant.plugin('2', :command)
        def self.synopsis
          'open Trellis databases in Sequel Pro'
        end

        def initialize(argv, env)
          super

          @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

          @subcommands = Vagrant::Registry.new

          @subcommands.register(:open) do
            require_relative 'open'
            Open
          end
        end

        def execute
          return help if (@main_args & %w[-h --help]).any?

          command_class = @subcommands.get(@sub_command&.to_sym)
          return help unless command_class

          # Initialize and execute the command class
          command_class.new(@sub_args, @env).execute
        end

        private

        def help
          option_parser = OptionParser.new do |opts|
            opts.banner = 'Usage: vagrant trellis-sequel <command> [<args>]'
            opts.separator ''
            opts.separator 'Available subcommands:'

            @subcommands.keys.sort.each do |key|
              opts.separator "     #{key}"
            end

            opts.separator ''
            opts.separator "For help on any individual command run 'vagrant trellis-sequel COMMAND -h'"
          end

          @env.ui.info(option_parser.help, prefix: false)
        end
      end
    end
  end
end
