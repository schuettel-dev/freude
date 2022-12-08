class Forms::FieldErrorsComponent < ViewComponent::Base
  def initialize(record, field)
    @record = record
    @field = field
    super()
  end

  def render?
    field_errors.any?
  end

  def field_errors
    @field_errors ||= @record.errors.messages_for(@field)
  end
end
