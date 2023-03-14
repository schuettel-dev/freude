class User < ApplicationRecord
  validates :name, :token, presence: true
  validates :token, uniqueness: true

  attr_readonly :token

  before_validation :initialize_token, if: :new_record?
  before_validation :initialize_color, if: :new_record?

  has_many :games, dependent: :destroy

  private

  def initialize_token
    self.token ||= SecureRandom.alphanumeric(16)
  end

  def initialize_color
    self.color ||= Array.new(3).map { rand(0..255).to_s(16).rjust(2, "0") }.join.prepend("#")
  end
end
