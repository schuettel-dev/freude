class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  before_validation :initialize_type, if: :new_record?

  private

  def initialize_type
    self.type ||= [self.class, game&.class&.name&.demodulize].compact.join("::")
  end
end
