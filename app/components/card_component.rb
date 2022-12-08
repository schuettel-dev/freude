class CardComponent < ViewComponent::Base
  def call
    tag.div(content, class: "border-8 bg-white border-indigo-600 rounded-lg border-t-2 border-l-2 p-4")
  end
end
