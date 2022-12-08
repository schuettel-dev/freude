class GameInstancePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      GameInstance.for_user(user)
    end
  end
end
