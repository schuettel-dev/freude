require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by(ENV["DEBUG"].present? ? :selenium : :rack_test, using: :firefox)

  def using_browser(&)
    driver = ENV["DEBUG"].present? ? :selenium : :selenium_headless
    Capybara.using_driver(driver, &)
  end

  def sign_in(user_fixture_key)
    visit new_session_path

    assert_selector "h1", text: "Sign in"

    fill_in "Token", with: users(user_fixture_key).token
    click_on "Join games"
  end

  def sign_out
    visit "/profile"
    click_on "Sign out"
  end

  def navigate_to(target)
    within "header" do
      click_on target, exact_text: true
    end
  end

  def assert_no_link_or_button(...)
    assert_no_link(...)
    assert_no_button(...)
  end

  def assert_description_list(term, description)
    assert_selector "dl dt", exact_text: term do |element|
      assert(
        element.sibling("dd").has_text?(description),
        <<~MESSAGE
          Expected <dt> with term '#{term}' to have a sibling <dd> with description '#{description}', but hasn't.
          Instead sibling <dd> has text '#{element.sibling("dd").text}'
        MESSAGE
      )
    end
  end

  def goto_game(group_name)
    within_game_list_item(group_name) do
      click_on "Goto game"
    end
  end

  def within_game_template_section(game_name, &)
    game_title_element = find "h2", text: game_name
    within(game_title_element.ancestor("section"), &)
  end

  def within_game_list_item(group_name, &)
    group_title_element = find "h2", text: group_name
    within(group_title_element.ancestor("section"), &)
  end

  def within_game_card(section_title, &)
    assert_selector "h2", text: section_title do |h2_element|
      within(h2_element.ancestor(".card-component"), &)
    end
  end

  def stale_element!(element, text: "[[[STALED BY TEST]]]")
    element.execute_script(
      <<~JS
        this.innerHTML = `#{text}`
      JS
    )
  end
end
