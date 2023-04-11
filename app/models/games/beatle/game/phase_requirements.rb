module Games::Beatle::Game::PhaseRequirements
  extend ActiveSupport::Concern

  def validate_phase_requirements_for(to_phase)
    case to_phase.to_sym
    when :guessing
      validate_for_guessing_phase
    when :ended
      validate_for_ended_phase
    else
      true
    end
  end

  private

  def validate_for_guessing_phase
    validate_minimum_players_reached
    validate_minimum_players_playlists_ready
  end

  def validate_for_ended_phase
    validate_no_unguessed_playlist_guesses
  end

  def validate_minimum_players_reached
    return if minimum_players_reached?

    errors.add(:base, :minimum_players_not_reached)
  end

  def validate_minimum_players_playlists_ready
    return if playlists.ready_to_guess.count >= minimum_players

    errors.add(:base, :not_enough_playlists_ready)
  end

  def validate_no_unguessed_playlist_guesses
    return if playlist_guesses.unguessed.none?

    errors.add(:base, :still_unguessed_playlists)
  end
end
