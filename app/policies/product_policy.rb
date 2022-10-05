class ProductPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    mine?
  end

  def destroy?
    mine?
  end

  def create?
    mine?
  end

  def index?
    true
  end

  def show?
    true
  end

  def buy?
    user.role == User::BUYER_ROLE
  end

  private

  def mine?
    user.id == record.seller_id
  end
end
