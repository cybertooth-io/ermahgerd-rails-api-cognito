# frozen_string_literal: true

# All models inherit from this class.
class ApplicationRecord < ActiveRecord::Base
  include ScopeByDistinct
  include ScopeById

  self.abstract_class = true
end
