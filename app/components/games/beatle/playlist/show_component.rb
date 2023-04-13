class Games::Beatle::Playlist::ShowComponent < ApplicationComponent
  attr_reader :playlist, :current_player

  delegate :game, to: :playlist

  def initialize(playlist:, current_player:)
    @playlist = playlist
    @current_player = current_player
    super()
  end

  def right_guesses
    @right_guesses ||= playlist.guesses.right_guessed
  end

  def wrong_guesses
    @wrong_guesses ||= playlist.guesses.wrong_guessed
  end

  def players_grouped_by_wrong_guesses_count
    @players_grouped_by_wrong_guesses_count ||= find_players_grouped_by_wrong_guesses_count
  end

  def wrong_guess_count_for_player_id(player_id)
    tallied_wrong_guessed_player_ids[player_id]
  end

  def ordered_playlists
    game.playlists.order_by_user_name
  end

  def current_players_playlist?
    playlist.player == current_player
  end

  def current_player_guessed_it_right?
    current_players_guess.guessed_player == playlist.player
  end

  # def only_player_guessed_it_right?
  #   right_guesses.size == 1 && right_guesses.first.player == player
  # end

  def current_players_guess
    @current_players_guess ||= playlist.guesses.find_by(player: current_player)
  end

  private

  def find_players_grouped_by_wrong_guesses_count
    wrong_guessed_players = Player.joins(:user).where(id: tallied_wrong_guessed_player_ids.keys)

    wrong_guessed_players.group_by { tallied_wrong_guessed_player_ids[_1.id] }.sort.reverse.to_h
  end

  def tallied_wrong_guessed_player_ids
    @tallied_wrong_guessed_player_ids ||= wrong_guesses.pluck(:guessed_player_id).tally
  end
end
