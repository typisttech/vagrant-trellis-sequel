# frozen_string_literal: true

begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant Trellis Sequel plugin must be run within Vagrant.'
end

require 'vagrant_plugins/trellis_sequel/identity'
require 'vagrant_plugins/trellis_sequel/plugin'
