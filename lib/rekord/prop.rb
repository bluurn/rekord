module Rekord
  class Prop
    def initialize(val)
      @val = val
    end

    def get
      @val
    end

    def set(new_val)
      @val = new_val
    end
  end
end
