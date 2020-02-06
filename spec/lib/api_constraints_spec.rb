# frozen_string_literal: true

RSpec.describe ApiConstraints do
  subject { described_class.new(version: version, default: default) }

  let(:version) { 1 }

  describe "#matches?" do
    context "when is the default version" do
      let(:default) { true }

      context "and no headers are present" do
        it "matches the request" do
          req = request_for(version: nil)
          expect(subject.matches?(req)).to eq(true)
        end
      end

      context "and headers are present for the correct version" do
        it "matches the request" do
          req = request_for(version: version)
          expect(subject.matches?(req)).to eq(true)
        end
      end

      context "and headers are present for another version" do
        it "matches the request" do
          req = request_for(version: 99)
          expect(subject.matches?(req)).to eq(true)
        end
      end
    end

    context "when is not the default version" do
      let(:default) { false }

      context "and no headers are present" do
        it "doesn't match the request" do
          req = request_for(version: nil)
          expect(subject.matches?(req)).to eq(false)
        end
      end

      context "and headers are present for the correct version" do
        it "matches the request" do
          req = request_for(version: version)
          expect(subject.matches?(req)).to eq(true)
        end
      end

      context "and headers are present for another version" do
        it "doesn't match the request" do
          req = request_for(version: 99)
          expect(subject.matches?(req)).to eq(false)
        end
      end
    end
  end

  private

  def request_for(version:)
    req = ActionDispatch::TestRequest.create
    req.accept = "application/vnd.tico.v#{version}+json" if version
    req
  end
end
