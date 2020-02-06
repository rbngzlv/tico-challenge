# frozen_string_literal: true

RSpec.describe Platform do
  describe "TYPES" do
    it "is an array of strings" do
      expect(Platform::TYPES).to be_an_instance_of(Array)
      expect(Platform::TYPES).to all(be_kind_of(String))
    end
  end
end
