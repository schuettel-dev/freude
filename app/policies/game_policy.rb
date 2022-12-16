class GamePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.players_users.include?(user)
  end

  def new?
    true
  end

  def create?
    true
  end

  def edit?
    record.user == user
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def join?
    true
  end

  class Scope < Scope
    def resolve
      Game.for_user(user)
    end
  end
end
