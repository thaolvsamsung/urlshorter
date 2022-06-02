require "application_system_test_case"

class ShortenUrlsTest < ApplicationSystemTestCase
  setup do
    @shorten_url = shorten_urls(:one)
  end

  test "visiting the index" do
    visit shorten_urls_url
    assert_selector "h1", text: "Shorten Urls"
  end

  test "creating a Shorten url" do
    visit shorten_urls_url
    click_on "New Shorten Url"

    fill_in "Category", with: @shorten_url.category
    fill_in "Click count", with: @shorten_url.click_count
    fill_in "Created at", with: @shorten_url.created_at
    fill_in "Expires at", with: @shorten_url.expires_at
    fill_in "Owner", with: @shorten_url.owner_id
    fill_in "Owner type", with: @shorten_url.owner_type
    fill_in "Unique key", with: @shorten_url.unique_key
    fill_in "Updated at", with: @shorten_url.updated_at
    fill_in "Url", with: @shorten_url.url
    click_on "Create Shorten url"

    assert_text "Shorten url was successfully created"
    click_on "Back"
  end

  test "updating a Shorten url" do
    visit shorten_urls_url
    click_on "Edit", match: :first

    fill_in "Category", with: @shorten_url.category
    fill_in "Click count", with: @shorten_url.click_count
    fill_in "Created at", with: @shorten_url.created_at
    fill_in "Expires at", with: @shorten_url.expires_at
    fill_in "Owner", with: @shorten_url.owner_id
    fill_in "Owner type", with: @shorten_url.owner_type
    fill_in "Unique key", with: @shorten_url.unique_key
    fill_in "Updated at", with: @shorten_url.updated_at
    fill_in "Url", with: @shorten_url.url
    click_on "Update Shorten url"

    assert_text "Shorten url was successfully updated"
    click_on "Back"
  end

  test "destroying a Shorten url" do
    visit shorten_urls_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shorten url was successfully destroyed"
  end
end
