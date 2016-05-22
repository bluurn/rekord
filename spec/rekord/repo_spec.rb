require 'spec_helper'


describe Rekord::Repo do
  let(:model) do
    Class.new(Rekord::Base) do
      prop :title
      prop :author
    end
  end

  let(:record) do
    model.new
  end

  describe "instance methods" do
    it "should have methods" do
      %i(create update destroy).each do |method|
        expect(record).to respond_to(method)
      end
    end
    describe "#create" do
      it "should assign id to model instance" do
        pending "implement me"
      end
    end

    describe "#update" do
      it "should update record attributes" do
        pending "implement me"
      end
    end

    describe "#destroy" do
      it "should destroy record" do
        pending "implement me"
      end
    end
  end

  describe "class methods" do
    it "should have methods" do
      %i(find all where).each do |method|
        expect(model).to respond_to(method)
      end
    end

    describe ".find" do
      context "when there is no record with id" do
        it "raises exception" do
          pending "implement me"
        end
      end
      context "when there is record with id specified" do
        it "returns model" do
          pending "implement me"
        end
      end
    end
    describe ".all" do
      context "when records list isnt empty" do
        it "returns list of records" do
          pending "implement me"
        end
      end
      context "when there is nothing" do
        it "returns empty array" do
          pending "implement me"
        end
      end
    end

    describe ".where" do
      context "when we have records, matching the condition" do
        it "returns list of records" do
          pending "implement me"
        end
      end
      context "when no records mathing the condition" do
        it "returns empty array" do
          pending "implement me"
        end
      end
    end
  end
end
