# frozen_string_literal: true

class DepositForm
  include ActiveModel::Model

  VALID_DEPOSITS = [5, 10, 20, 50, 100].freeze

  attr_accessor(:user, :deposit)

  validates :deposit, inclusion: { in: VALID_DEPOSITS }

  def initialize(user, deposit)
    self.user = user
    self.deposit = deposit
  end

  def save
    if valid?
      user.deposit += deposit
      user.save
    else
      false
    end
  end
end
