module Games
  module Beatle
    class GamePolicy < GamePolicy
      def join?
        record.collecting?
      end
    end
  end
end
