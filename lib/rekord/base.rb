require "rekord/prop_methods"
require "rekord/repo"
require "rekord/persistent_storage"
require "rekord/config"

class Rekord::Base
  include Rekord::PropMethods
  include Rekord::RepoMethods
  include Rekord::Config

  configure do |c|
    c.storage = Rekord::PersistentStorage.new path: "rekords.pstore"
  end
end
