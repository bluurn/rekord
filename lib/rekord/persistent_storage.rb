require 'rekord/abstract_storage'
require 'pstore'

module Rekord
  class PersistentStorage < AbstractStorage

    def initialize(adapter = PStore, path:)
      @cache = {}
      @adapter = adapter.new(path)
    end

    def get_by_key(table, key, key_val)
      data_from(table).find { |rec| rec[key] == key_val }
    end

    def get_all(table)
      data_from table
    end

    def get_all_by_condition(table, condition)
      data_from(table).select do |rec|
        rec.values_at(*condition.keys) == condition.values
      end
    end

    def put(table, key, data)
      new_key_val = get_new_key_val(table)
      data[key] = new_key_val
      data_from(table) << data
      commit!
      data
    end

    def delete(table, key, key_val)
      record = data_from(table).delete_if do |rec|
        rec[key] == key_val
      end.delete(key)
      commit!
      record
    end

    def update(table, key, key_val, data)
      record = get_by_key(table, key, key_val)
      record.merge!(data)
      commit!
      record
    end

    def commit!
      @adapter.transaction do
        @cache.dup.each do |data_root_name, value|
          @adapter[data_root_name] = value
        end
      end
    end

    protected

    def get_new_key_val(table)
      @cache["#{table}_key"] ||= data_from(table).count + 1
    end

    def data_from(table)
      @cache[table] || []
    end

    def load_data!
      readonly = true
      @adapter.transaction(readonly) do
        @adapter.roots.each do |data_root_name|
          @cache[data_root_name] = @adapter[data_root_name]
        end
      end
    end
  end
end
