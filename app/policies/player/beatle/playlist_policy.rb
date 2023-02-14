class Player::Beatle::PlaylistPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def edit?
    show? && record.game.collecting?
  end

  def update?
    edit?
  end

  class Scope < Scope
    def resolve
      Player::Beatle::Playlist.for_user(user)
    end
  end
end
