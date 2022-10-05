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
    its_me?
  end

  def create?
    true
  end

  def show?
    its_me?
  end

  def destroy?
    its_me?
  end
private
  def its_me?
    user.id = record.id
  end
end
