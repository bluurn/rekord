require 'spec_helper'
require 'support/fake_storage'


describe Rekord::Repo do

  let(:model) do
    class Book < Rekord::Base
      prop :id
      prop :title
      prop :author
    end
    Book
  end

  let(:record) do
    model.new
  end

  let(:title) { "Tom Sawyer" }
  let(:author) { "Mark Twain" }

  before(:each) do
    Rekord::Base.configure do |config|
      config.storage = FakeStorage.new
    end
  end

  describe "instance methods" do
    it "should have methods" do
      %i(update destroy).each do |method|
        expect(record).to respond_to(method)
      end
    end

    describe "#update" do
      it "should update record attributes" do
        last_record = model.find(2)
        last_record.update title: "1984", author: "George Orwell"

        expect(last_record.title).to eq "1984"
        expect(last_record.author).to eq "George Orwell"
        expect(last_record.persisted?).to be_truthy
      end
    end

    describe "#destroy" do
      it "should destroy record" do
        last_record = model.find(2)
        old_size = model.all.size
        new_size = model.all.size
        last_record.destroy
        expect(last_record.persisted?).to be_falsey
        expect(last_record.key_val).to be_nil
      end
    end
  end

  describe "class methods" do
    it "should have methods" do
      %i(find all where create table_name table_name= key key=).
        each do |method|
        expect(model).to respond_to(method)
      end
    end

    describe ".table_name" do
      it "should convert class name to table name" do
        expect(model.table_name).to eq(:books)
      end
    end

    describe ".find" do
      context "when there is no record with id" do
        it "raises exception" do
          expect { model.find(10) }.to raise_error Rekord::NotFound
        end
      end
      context "when there is record with id specified" do
        it "returns model" do
          record = model.find(1)
          expect(record.id).to eq 1
          expect(record.title).to eq title
          expect(record.author).to eq author
        end
      end
    end

    describe "#create" do
      it "should create new record" do
        new_book = model.create(title: "Brave New World", author: "Aldous Huxley")
        expect(new_book.id).not_to be_nil
        expect(new_book.persisted?).to be_truthy
      end
    end

    describe ".all" do
      context "when records list isnt empty" do
        it "returns list of records" do
          expect(model.all.size).to eq(3)
        end
      end
      context "when there is nothing" do
        let(:empty_model) do
          class Empty < Rekord::Base
            prop :some_prop
          end
          Empty
        end
        it "returns empty array" do
          expect(empty_model.all).to eq([])
        end
      end
    end

    describe ".where" do
      context "when we have records, matching the condition" do
        it "returns list of records" do
          expect(model.where(title: "Tom Sawyer").first.author).to eq "Mark Twain"
        end
      end
      context "when no records mathing the condition" do
        it "returns empty array" do
          expect(model.where(title: "Anarchist Cookbook")).to be_empty
        end
      end
    end
  end
end
