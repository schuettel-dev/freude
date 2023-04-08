class Games::Beatle::PaginationComponent < ApplicationComponent
  attr_reader :ordered_items, :current_item

  def initialize(ordered_items, current_item)
    @ordered_items = ordered_items
    @current_item = current_item
    super()
  end

  def render?
    ordered_items.size > 1
  end

  def previous_item
    return if previous_item_index.negative?

    ordered_items[previous_item_index]
  end

  def next_item
    return if next_item_index >= ordered_items.size

    ordered_items[current_item_index.next]
  end

  private

  def previous_item_index
    @previous_item_index ||= current_item_index.pred
  end

  def current_item_index
    @current_item_index ||= ordered_items.index(current_item)
  end

  def next_item_index
    @next_item_index ||= current_item_index.next
  end
end
