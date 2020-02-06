# frozen_string_literal: true

require "dry/validation"

Dry::Validation.load_extensions(:monads)

class ApplicationContract < Dry::Validation::Contract
end
