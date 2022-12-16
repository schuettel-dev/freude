class QrCodeComponent < ViewComponent::Base
  def initialize(url:)
    @url = url
    super()
  end

  def call
    tag.div(svg.html_safe, class: "aspect-square w-full") # rubocop:disable Rails/OutputSafety
  end

  private

  def qrcode
    RQRCode::QRCode.new(@url)
  end

  def svg
    @svg ||= qrcode.as_svg(
      color: :currentColor,
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true,
      viewbox: true,
      svg_attributes: { class: "block mx-auto" }
    )
  end
end
