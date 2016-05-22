class FakeStorage < Rekord::AbstractStorage
  @@CACHE = {
    :books => [
      { id: 0, title: "A book to delete", author: "Anonymous" },
      { id: 1, title: "Tom Sawyer", author: "Mark Twain" },
      { id: 2, title: "Crime and Punishment", author: "Fyodor Dostoevsky" }
    ]
  }.freeze

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
    last_record = data_from(table).last
    new_id = last_record[key] || 0
    data[key] = new_id
    data
  end

  def delete(table, key, key_val)
    record = get_by_key(table, key, key_val)
    record.delete(key)
    record
  end

  def update(table, key, key_val, data)
    record = get_by_key(table, key, key_val)
    new_record = record.merge(data)
    new_record
  end

  private

  def data_from(table)
    @@CACHE[table] || []
  end

end
