class Player::Beatle::Playlist < ApplicationRecord
  SongUrl = Struct.new(:playlist, :song_url_attribute) do
    def provider
      @provider ||= find_provider
    end

    def url
      playlist[song_url_attribute]
    end

    private

    def find_provider
      return :__blank__ if url.blank?
      return :spotify if url.include?("spotify.com/track/")
      return :youtube if false # TODO

      :__invalid__
    end
  end

  self.table_name = :player_beatle_playlists

  belongs_to :player

  delegate :user, to: :player

  scope :of_game, ->(game) { joins(:player).where(players: { game: }) }
  scope :for_user, ->(user) { joins(:player).where(players: { user: }) }

  def song_urls
    [
      to_song_url(:song_1_url),
      to_song_url(:song_2_url),
      to_song_url(:song_3_url)
    ]
  end

  private

  def to_song_url(song_url_attribute)
    SongUrl.new(self, song_url_attribute)
  end
end
