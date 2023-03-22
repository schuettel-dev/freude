module Games
  module Beatle
    class Playlist < ApplicationRecord
      SongUrl = Struct.new(:playlist, :song_url_attribute) do
        def provider
          @provider ||= find_provider
        end

        def status
          @status ||= find_status
        end

        def url
          playlist[song_url_attribute]
        end

        def valid?
          status == :valid
        end

        private

        def find_provider
          return :spotify if url.include?("spotify.com/track/")
          # return :youtube if false # TODO
        end

        def find_status
          return :blank if url.blank?
          return :valid if provider.in?([:spotify, :youtube])

          :invalid
        end
      end

      self.table_name = :games_beatle_playlists

      belongs_to :player

      delegate :game, :user, to: :player

      scope :of_game, ->(game) { joins(:player).where(players: { game: }) }
      scope :for_user, ->(user) { joins(:player).where(players: { user: }) }

      def song_urls
        [
          to_song_url(:song_1_url),
          to_song_url(:song_2_url),
          to_song_url(:song_3_url)
        ]
      end

      def reset_song_urls
        update(
          song_1_url: nil,
          song_2_url: nil,
          song_3_url: nil
        )
      end

      def broadcast_inline_statuses
        comp = Games::Beatle::Playlist::InlineStatusComponent.new(playlist: self)
        broadcast_replace_to(
          game,
          :players_section,
          target: comp.to_dom_id,
          html: ApplicationController.render(comp, layout: false)
        )
      end

      private

      def to_song_url(song_url_attribute)
        SongUrl.new(self, song_url_attribute)
      end
    end
  end
end