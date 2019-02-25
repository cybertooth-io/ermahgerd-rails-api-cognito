# frozen_string_literal: true

# This is the linking table for the Has And Belongs To Many relationship between users & roles
class RolesUser < ApplicationRecord
  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :role
  belongs_to :user
end
