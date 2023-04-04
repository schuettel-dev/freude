class Games::Beatle::Playlist::ShowComponent < ApplicationComponent
  attr_reader :playlist, :pagy

  delegate :game, to: :playlist

  def initialize(playlist:)
    @playlist = playlist
    super()
  end

  def right_guesses
    @right_guesses ||= playlist.guesses.right_guessed
  end

  def wrong_guesses
    @wrong_guesses ||= playlist.guesses.wrong_guessed
  end

  def wrong_guesses_grouped_by_guessed_player
    @wrong_guesses_grouped_by_guessed_player ||= find_wrong_guesses_grouped_by_guessed_player
  end

  def wrong_guess_count_for_player_id(player_id)
    tallied_wrong_guessed_player_ids[player_id]
  end

  def ordered_playlists
    game.playlists.order_by_user_name
  end

  private

  def find_wrong_guesses_grouped_by_guessed_player
    wrong_guessed_players = Player.joins(:user).where(id: tallied_wrong_guessed_player_ids.keys)

    wrong_guessed_players.sort_by { -tallied_wrong_guessed_player_ids[_1.id] }
  end



  def tallied_wrong_guessed_player_ids
    @tallied_wrong_guessed_player_ids ||= wrong_guesses.pluck(:guessed_player_id).tally
  end
end
