class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.blank?
        scope.where(role: User::SELLER_ROLE)
      else
        scope.where(id: user.id).or(User.where(role: User::SELLER_ROLE))
      end
    end
  end

  def update?
    user.id = record.id
  end

  def create
    true
  end

  def show
    user.id = record.id
  end
end
