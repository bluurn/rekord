require 'spec_helper'

class Book < Rekord::Base
  prop :title
  prop :author
end

describe Book do
  let(:title) { "Tom Sawyer" }
  let(:author) { "Mark Twain" }
  let(:new_title) { "Huckleberry Finn" }
  let(:props)  { { title: title, author: author } }

  describe "#new" do
    it "should populate props from hash" do
      book = described_class.new(title: title, author: author)

      expect(book.title).to eq title
      expect(book.author).to eq author
    end

    it "should populate props if block given" do
      book = described_class.new do |b|
        b.title = title
        b.author = author
      end
      expect(book.title).to eq title
      expect(book.author).to eq author
    end
  end

  describe "setter" do
    it "should set prop" do
      book = described_class.new(props)
      book.title = new_title
      expect(book.title).to eq(new_title)
    end
  end

  describe "#props" do
    it "should return hash of prop-value" do
      book = described_class.new(props)
      expect(book.props).to eq props
    end
  end

  describe "#props=" do
    it "should assign new props from hash" do
      book = described_class.new(props)
      book.props = { title: new_title }
      expect(book.props).to eq({ title: new_title, author: author })
    end
  end
end
