class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game_instance

  before_validation :initialize_type, if: :new_record?

  private

  def initialize_type
    self.type ||= "Player::#{game_instance.class.name.demodulize}"
  end
end
