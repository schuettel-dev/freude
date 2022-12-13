class HeroiconComponent < ViewComponent::Base
  DEFAULT_OPTIONS = {
    class: "w-6 h-6"
  }.freeze

  def initialize(icon_key, options = {})
    @icon_key = icon_key
    @options = DEFAULT_OPTIONS.deep_dup.merge(options)
    super()
  end

  def call
    tag.div(**@options) do
      Rails.root.join("app/assets/images/icons/heroicons/#{file_name}").read.html_safe # rubocop:disable Rails/OutputSafety
    end
  end

  private

  def file_name
    @icon_key.to_s.downcase.dasherize.ext(".svg")
  end
end
