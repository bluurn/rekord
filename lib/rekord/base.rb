require "rekord/prop_methods"
require "rekord/repo"
require "rekord/storage"

class Rekord::Base
  include Rekord::PropMethods
  include Rekord::RepoMethods


  class << self
    def config
      @config ||= Struct.new(:storage).new
    end

    def configure
      yield config if block_given?
    end
  end
end
