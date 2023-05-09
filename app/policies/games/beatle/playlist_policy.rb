module Games
  module Beatle
    class PlaylistPolicy < ApplicationPolicy
      def show?
        own? || record.game.ended?
      end

      def edit?
        own? && record.game.collecting?
      end

      def update?
        edit?
      end

      def own?
        record.user == user
      end

      class Scope < Scope
        def resolve
          Games::Beatle::Playlist.for_user(user)
        end
      end
    end
  end
end
