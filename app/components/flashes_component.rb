class FlashesComponent < ViewComponent::Base
  attr_reader :flash

  def initialize(flash:)
    @flash = flash
    super()
  end

  def render?
    flash.any?
  end
end
