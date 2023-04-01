module Games
  module Beatle
    class GamePolicy < GamePolicy
      def join?
        record.collecting?
      end

      def guess?
        record.guessing?
      end

      def results?
        record.ended?
      end
    end
  end
end
