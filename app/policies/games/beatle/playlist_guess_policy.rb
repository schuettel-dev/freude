class Games::Beatle::PlaylistGuessPolicy < ApplicationPolicy
  def edit?
    record.player.user == user && record.game.guessing?
  end

  def update?
    edit?
  end

  class Scope < Scope
    def resolve
      Games::Beatle::PlaylistGuess.for_user(user)
    end
  end
end
