class Games::Beatle::AllPlaylistsInlineStatusComponent < ApplicationComponent
  def initialize(game:)
    @game = game
    super()
  end

  def call # rubocop:disable Metrics/AbcSize
    tag.div(class: "flex #{to_css_class}", title:, id: to_dom_id) do
      concat render HeroiconComponent.new(:"musical-note", class: css_classes_for_threshold(1 / 3))
      concat render HeroiconComponent.new(:"musical-note", class: css_classes_for_threshold(2 / 3))
      concat render HeroiconComponent.new(:"musical-note", class: css_classes_for_threshold(1))
    end
  end

  def to_dom_id
    dom_id(game, :all_playlists_inline_status)
  end

  private

  attr_reader :game

  def css_classes_for_threshold(threshold)
    class_names(
      "w-5 h-5",
      text_color(threshold)
    )
  end

  def text_color(threshold)
    return "text-green-600" if all_playlists_ready?
    return "text-gray-300" if percentage < (threshold * 100)

    "text-indigo-400"
  end

  def title
    return t("games.beatle.shared.all_playlists_are_ready_to_guess") if all_playlists_ready?

    t("games.beatle.shared.count_playlists_are_incomplete", count: incomplete_playlists_count)
  end

  def all_playlists_ready?
    percentage == 100
  end

  def percentage
    @percentage ||= find_percentage
  end

  def find_percentage
    complete_playlists_count.to_f / total_playlists_count * 100
  end

  def complete_playlists_count
    total_playlists_count - incomplete_playlists_count
  end

  def incomplete_playlists_count
    @incomplete_playlists_count ||= game_playlists.count { !_1.song_urls.all?(&:valid?) }
  end

  def total_playlists_count
    game_playlists.size
  end

  def game_playlists
    @game_playlists ||= game.playlists
  end
end
