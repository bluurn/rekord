require 'bundler/setup'
require 'logger'
Bundler.setup
require 'rekord'


storage_path = File.join(File.dirname(__FILE__), 'fixtures', 'storage.pstore')

def setup_storage!(storage_path)
  puts "Creating storage: %s" % storage_path
  Rekord::Base.configure do |c|
    c.storage = Rekord::PersistentStorage.new(path: storage_path)
  end
end

def flush_storage!(storage_path)
  puts "Flushing storage: %s" % storage_path
  File.write(storage_path, '')
end

RSpec.configure do |config|
  config.before(:all) { setup_storage!(storage_path) }
  config.after(:all) { flush_storage!(storage_path) }
end
