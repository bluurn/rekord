require 'active_support/inflector'

module Rekord
  class Repo
    attr_reader :storage

    def initialize(storage)
      @storage = storage
    end

    def find(model, key_val)
      data = storage.get_by_key(model.table_name, model.key, key_val)
      if data.nil?
        raise NotFound
      else
        model.new data
      end
    end

    def create(model, props)
      storage.put(model.table_name, model.key, props)
    end

    def update(model, instance, props)
      storage.update(model.table_name, model.key, instance.key_val, props)
    end

    def destroy(model, instance)
      storage.delete(model.table_name, model.key, instance.key_val)
    end

    def where(model, condition)
      data_list = storage.get_all_by_condition(model.table_name, condition)
      data_list.map { |datum| model.new datum }
    end

    def all(model)
      data_list = storage.get_all(model.table_name)
      data_list.map { |datum| model.new datum }
    end
  end

  module RepoMethods
    def self.included(base)
      base.extend ClassMethods
    end

    def save
      self.props = if persisted? then
                     self.class.repo.update(self.class, self, new_props)
                   else
                     self.class.repo.create(self.class, self.props)
                   end
    end


    def update(new_props)
      self.props = self.class.repo.update(self.class, self, new_props)
      self
    end

    def destroy
      self.class.repo.destroy(self.class, self)
      self.key_val = nil
      self
    end

    def key_val
      send(self.class.key)
    end

    def key_val=(new_key_val)
      send("#{self.class.key}=", new_key_val)
    end

    def persisted?
      !new_record?
    end

    def new_record?
      key_val.nil?
    end

    module ClassMethods
      def repo
        @repo ||= Repo.new(superclass.config.storage)
      end

      def table_name
        @table_name ||= name.tableize.to_sym
      end

      def table_name=(new_table_name)
        @table_name = new_table_name.to_sym
      end

      def key=(new_key)
        @key = new_key
      end

      def key
        @key ||= :id
      end

      def find(id)
        repo.find(self, id)
      end

      def create(props)
        data = repo.create(self, props)
        new data
      end

      def where(**condition)
        repo.where(self, condition)
      end

      def all
        repo.all(self)
      end

      def count
        all.count
      end
    end
  end
end
