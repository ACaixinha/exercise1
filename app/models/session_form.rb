class SessionForm
  include ActiveModel::Model
  attr_accessor :username, :password

  validates :username, :password, presence: true
end
