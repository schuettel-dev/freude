class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

  def decorate
    @decorate ||= "#{self.class}Decorator".constantize.new(self)
  end

  def broadcast_replace_component(component)
    broadcast_replace(target: component.to_dom_id,
                      html: ApplicationController.render(component, layout: false))
  end
end
