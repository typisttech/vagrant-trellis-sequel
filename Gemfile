# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# To make `$ bundle exec vagrant` works
embedded_directories = %w[/Applications/Vagrant/embedded /opt/vagrant/embedded]
embedded_directories.each do |path|
  ENV['VAGRANT_INSTALLER_EMBEDDED_DIR'] = path if File.directory?(path)
end

unless ENV.key?('VAGRANT_INSTALLER_EMBEDDED_DIR')
  $stderr.puts "Couldn't find a packaged install of vagrant, and we need this"
  $stderr.puts 'in order to make use of the RubyEncoder libraries.'
  $stderr.puts 'I looked in:'
  embedded_locations.each do |path|
    $stderr.puts "  #{path}"
  end
end

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem 'vagrant', github: 'mitchellh/vagrant'
end

group :plugins do
  gemspec
end
