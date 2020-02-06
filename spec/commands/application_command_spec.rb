# frozen_string_literal: true

RSpec.describe ApplicationCommand do
  describe "validation contract" do
    it "raises an error if doesn't have a contract a default contract" do
      expect { described_class.new }.to raise_error("Implement this method in your subclass or provide a contract: param when initializing the instance")
    end

    it "doesn't raises an error if receives a contract" do
      expect { described_class.new(contract: Object) }.not_to raise_error
    end
  end
end
