# frozen_string_literal: true

# All models inherit from this class.
class ApplicationRecord < ActiveRecord::Base
  include Ermahgerd::Models::Concerns::ScopeByDistinct
  include Ermahgerd::Models::Concerns::ScopeById

  self.abstract_class = true
end
