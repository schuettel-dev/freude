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
    admin?
  end

  def update?
    admin?
  end

  def update_phase?
    admin?
  end

  def destroy?
    admin?
  end

  def join?
    raise "implement in subclass"
  end

  def admin?
    record.user == user
  end

  class Scope < Scope
    def resolve
      Game.for_user(user)
    end
  end
end
