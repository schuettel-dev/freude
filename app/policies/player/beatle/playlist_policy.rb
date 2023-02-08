class Player::Beatle::PlaylistPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  class Scope < Scope
    def resolve
      Player::Beatle::Playlist.for_user(user)
    end
  end
end
