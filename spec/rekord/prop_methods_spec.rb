require 'spec_helper'

describe Rekord::PropMethods do

  describe "model with injected PropMethods" do
    let(:model) do
      Class.new do
        include Rekord::PropMethods
        prop :title
        prop :author
      end
    end

    let(:title) { "Tom Sawyer" }
    let(:author) { "Mark Twain" }
    let(:new_title) { "Huckleberry Finn" }
    let(:props)  { { title: title, author: author } }

    describe "#new" do
      it "should populate props from hash" do
        book = model.new(title: title, author: author)

        expect(book.title).to eq title
        expect(book.author).to eq author
      end

      it "should populate props if block given" do
        book = model.new do |b|
          b.title = title
          b.author = author
        end
        expect(book.title).to eq title
        expect(book.author).to eq author
      end

      context "when no params were specified" do
        it "should populate model with default ones" do
          book = model.new
          expect(book.title).to eq nil
          expect(book.author).to eq nil
        end
      end
    end

    describe "#:prop_name=" do
      it "should set prop" do
        book = model.new(props)
        book.title = new_title
        expect(book.title).to eq(new_title)
      end
    end

    describe "#props" do
      it "should return hash of prop-value" do
        book = model.new(props)
        expect(book.props).to eq props
      end
    end

    describe "#props=" do
      it "should assign new props from hash" do
        book = model.new(props)
        book.props = { title: new_title }
        expect(book.props).to eq({ title: new_title, author: author })
      end
    end
  end
end
