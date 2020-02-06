# frozen_string_literal: true

RSpec.describe Platforms::UpdateCommand do
  subject(:result) { described_class.new(contract: contract).call(record, {}) }

  let(:failure_contract) do
    Class.new(ApplicationContract) do
      json { required(:any).value(:str?) }
    end
  end

  let(:success_contract) do
    Class.new(ApplicationContract) do
      json { optional(:any).value(:str?) }
    end
  end

  let(:record) { build_stubbed(:platform) }

  it "doesn't has a default contract" do
    expect { described_class.new }.to raise_error("Implement this method in your subclass or provide a contract: param when initializing the instance")
  end

  describe "#call" do
    context "when the schema validation fails" do
      let(:contract) { failure_contract }

      it "returns a failure with errors" do
        expect(result).to be_failure
        expect(result.failure).to be_kind_of(Dry::Validation::Result)
        expect(result.failure.errors.to_h).to include(any: ["is missing"])
      end
    end

    context "when the record validation fails" do
      before do
        allow(record).to receive(:save).and_return(false)
      end

      let(:contract) { success_contract }

      it "returns a failure with errors" do
        expect(result).to be_failure

        code, failure = result.failure
        expect(code).to eq(:active_record_error)
        expect(failure.errors).to be_a(Hash)
      end
    end

    context "when all is valid" do
      before do
        allow(record).to receive(:save).and_return(true)
      end

      let(:contract) { success_contract }

      it "updates enqueue the job to update the platform" do
        expect { result }.to have_enqueued_job(UpdatePlatformJob)
      end

      it "returns success with the record" do
        expect(result).to be_success

        code, returned_record = result.value!
        expect(code).to eq(:ok)
        expect(returned_record).to eq(record)
      end
    end
  end
end
