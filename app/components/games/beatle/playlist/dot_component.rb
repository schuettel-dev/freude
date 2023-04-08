class Games::Beatle::Playlist::DotComponent < ApplicationComponent
  attr_reader :playlist, :current_playlist

  def initialize(playlist:, current_playlist:)
    @playlist = playlist
    @current_playlist = current_playlist
    super()
  end

  def call
    if current_playlist?
      tag.span(content, class: span_css_classes, title:)
    else
      link_to(
        content,
        game_beatle_playlist_path(playlist.game, playlist),
        class: link_to_css_classes,
        title:
      )
    end
  end

  private

  def current_playlist?
    playlist == current_playlist
  end

  def title
    playlist.player.decorate.display_name
  end

  def span_css_classes
    class_names(
      common_css_classes,
      bg_css_classes,
      "outline outline-offset-2 outline-4 outline-blue-400"
    )
  end

  def link_to_css_classes
    class_names(
      common_css_classes,
      bg_css_classes,
      "opacity-70 hover:opacity-100 transition"
    )
  end

  def common_css_classes
    "flex justify-center items-center text-xs w-8 h-8 rounded-full"
  end

  def bg_css_classes
    "bg-blue-300"
  end
end
