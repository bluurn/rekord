module Rekord
  class AbstractStorage
    def get_by_key(table, key, val)
      fail NotImplementedError
    end

    def get_all(table)
      fail NotImplementedError
    end

    def get_all_by_condition(table, condition)
      fail NotImplementedError
    end

    def put(table, data)
      fail NotImplementedError
    end

    def delete(table, key)
      fail NotImplementedError
    end

    def update(table, data)
      fail NotImplementedError
    end
  end
end
