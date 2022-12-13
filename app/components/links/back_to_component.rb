class Links::BackToComponent < ViewComponent::Base
  attr_reader :url, :body

  def initialize(url = nil, body = nil)
    @url = url
    @body = body
    super()
  end
end
