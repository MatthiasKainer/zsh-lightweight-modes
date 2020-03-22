require 'aruba/cucumber'
Aruba.configure do |config|
    # use current working directory
    config.home_directory = '/home/tester'
    config.allow_absolute_paths = true
  end
  