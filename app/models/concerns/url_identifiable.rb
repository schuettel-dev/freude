module UrlIdentifiable
  extend ActiveSupport::Concern

  def to_param
    url_identifier
  end
end
