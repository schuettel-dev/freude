class Games::Beatle::PlaylistComponent < ApplicationComponent
  attr_reader :playlist, :user

  def initialize(playlist:, user:)
    @playlist = playlist
    @user = user
    super()
  end

  def edit_playlist?
    playlist_policy.edit?
  end

  private

  def playlist_policy
    @playlist_policy ||= Pundit.policy(user, playlist)
  end
end
