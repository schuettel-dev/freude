class ApplicationComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include Turbo::StreamsHelper
  include ActionView::RecordIdentifier

  def to_css_class
    self.class.to_s.underscore.gsub(%r{/}, "__").dasherize
  end
end
