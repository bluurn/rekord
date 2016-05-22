require 'spec_helper'
require 'fixtures/book'
require 'fileutils'

def setup_test!
  fixtures_file_path = File.join(File.dirname(__FILE__), '..', 'fixtures', 'storage.pstore')
  clean_storage!
  Rekord::Base.configure do |c|
    c.storage = Rekord::PersistentStorage.new(path: fixtures_file_path)
  end
end

def clean_storage!
  fixtures_file_path = File.join(File.dirname(__FILE__), '..', 'fixtures', 'storage.pstore')
  File.write(fixtures_file_path, '')
end

describe Book do
  before(:all) { setup_test! }
  after(:all) { clean_storage! }

  describe "#create" do
    it "should create new record" do
      old_cnt = described_class.count
      book = described_class.create(title: "A Sound of Thunder", author: "Ray Bradburry")
      new_cnt = described_class.count

      expect(book.id).not_to be_nil
      expect(book).to be_persisted
      expect(new_cnt - old_cnt).to eq(1)
    end
  end

  describe "#find" do
    it "should find an existing record" do
      book = described_class.find(1)
      expect(book.title).to eq("A Sound of Thunder")
      expect(book.author).to eq("Ray Bradburry")
      expect(book).to be_persisted
    end
  end

  describe "#update" do
    it "should update an existing record" do
      book = described_class.find(1)
      book.update(author: "me:)")
      expect(book.author).to eq("me:)")
      expect(book).to be_persisted
    end
  end

  describe "#where" do
    before do
      1.upto(10).each { |x| described_class.create author: "Bot", title: "Book#{x}" }
    end
    it "should retreive a collection by condition" do
      collection = described_class.where author: "Bot"
      expect(collection.size).to eq 10
      expect(collection.all? {|c| c.author == "Bot"}).to be_truthy
    end
  end

  describe "#destroy" do
    it "should remove record" do
      wrong_record = described_class.create author: "wrong author", title: "wrong title"
      wrong_record.destroy
      expect(wrong_record.id).to be_nil
      expect(wrong_record).not_to be_persisted
    end
  end
end
