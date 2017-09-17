# frozen_string_literal: true

begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant Trellis Sequel plugin must be run within Vagrant.'
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
# Requiring 1.9.6 or later because of Ruby 2.3
if Vagrant::VERSION < '1.9.6'
  raise 'The Vagrant Trellis Sequel plugin is only compatible with Vagrant 1.9.6 or later'
end

require 'vagrant_plugins/trellis_sequel/identity'
require 'vagrant_plugins/trellis_sequel/plugin'
