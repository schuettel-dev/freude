class User < ApplicationRecord
  validates :name, :token, presence: true
  validates :token, uniqueness: true

  attr_readonly :token

  before_validation :initialize_token, if: :new_record?

  private

  def initialize_token
    self.token ||= SecureRandom.alphanumeric(16)
  end
end
