class Games::Beatle::Player::PlaylistGuessesInlineStatusComponent < ApplicationComponent
  DEFAULTS = {
    class: "w-8 h-8",
    hole_scale: 0,
    hole_color: "#fff"
  }.freeze

  def initialize(player:, **args)
    @player = player
    @args = DEFAULTS.dup.merge(args)
  end

  def call
    tag.div(class: css_classes, style:, title:)
  end

  private

  attr_reader :player, :args

  def css_classes
    class_names("conic-pie opacity-90 hover:opacity-100", args[:class])
  end

  def style
    [
      "--conic-pie-percent: #{guessed_percentage.round(5)}%;",
      "--conic-pie-hole-scale: #{args[:hole_scale]};",
      "--conic-pie-hole-color: #{args[:hole_color]};"
    ].join
  end

  def title
    t("games.beatle.shared.x_out_of_y_guessed", x: guessed_guesses_count, y: total_guesses_count)
  end

  def guessed_percentage
    @guessed_percentage ||= guessed_guesses_count.to_f / total_guesses_count * 100
  end

  def all_guessed?
    guessed_percentage == 100
  end

  def guessed_guesses_count
    @guessed_guesses_count ||= playlist_guesses.guessed.size
  end

  def total_guesses_count
    @total_guesses_count ||= playlist_guesses.size
  end

  def playlist_guesses
    @ordered_playlist ||= player.playlist_guesses
  end
end
