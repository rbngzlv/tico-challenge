# frozen_string_literal: true

require "ostruct"
require "dry-initializer"
require "dry/monads"
require "dry/monads/do"
require "dry/matcher"
require "dry/matcher/result_matcher"

class ApplicationCommand
  extend Dry::Initializer

  option :contract, optional: true, default: proc { default_contract }

  def self.inherited(subclass)
    super

    subclass.include Dry::Monads[:result]
    subclass.include Dry::Monads::Do.for(:call)
    subclass.include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
  end

  protected

  def default_contract
    raise "Implement this method in your subclass or provide a contract: param when initializing the instance"
  end

  def save_record(record, attributes = nil)
    record.assign_attributes(attributes) if attributes

    if record.save
      Success(record)
    else
      Failure([:active_record_error, OpenStruct.new(errors: record.errors.messages)])
    end
  end

  def validate(params)
    contract.new.call(params).to_monad
  end
end
