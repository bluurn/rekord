# Rekord

Active::Record's ugly brother, who was locked in the basement... until now! This gem is a dead simple implementation of AR with file persistent storage.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rekord'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rekord

## Usage

```ruby
  # Configuration:

  Rekord::Base.configure do |c|
    c.storage = Rekord::PersistentStorage.new(path: 'your.db')
  end

  # Model definition:
  class Book < Rekord::Base
    prop :id
    prop :title
    prop :author
  end

  # Create:
  book = Book.create(title: "A Sound of Thunder", author: "Ray Bradburry")

  # Init:
  book = Book.new(title: "A Sound of Thunder", author: "Ray Bradburry")
  book.new_record?

  # Props
  book.props = { author: "me" }
  book.props # { title: "A Sound of Thunder", author: "me" }
  book.save

  # Read:

  Book.find(1)
  Book.where author: 'me'

  # Update:
  book.update author: 'me'

  # Delete:
  book.destroy

```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
