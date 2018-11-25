# frozen_string_literal: true

module Ermahgerd
  module Errors
    class Error < StandardError
    end

    class Unauthorized < Error
    end

    class ClaimsVerification < Unauthorized
    end

    class SignatureExpired < Unauthorized
    end
  end
end
