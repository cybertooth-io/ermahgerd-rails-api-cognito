# frozen_string_literal: true

# A policy for the SINGULAR CurrentUser Resource/Model.  The current user is just that; the current signed in user.
# You can only show, update, and follow relationships
class CurrentUserPolicy < ApplicationPolicy
  def show?
    user.id == record.id
  end

  def sign_out?
    show?
  end

  def update?
    create?
  end

  # Use the request/controller's current_user to return a scope with only the current user inside it
  class Scope < Scope
    def resolve
      scope.by_id user.id
    end
  end
end
