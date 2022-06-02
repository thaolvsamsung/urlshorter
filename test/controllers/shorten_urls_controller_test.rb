require 'test_helper'

class ShortenUrlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shorten_url = shorten_urls(:one)
  end

  test "should get index" do
    get shorten_urls_url
    assert_response :success
  end

  test "should get new" do
    get new_shorten_url_url
    assert_response :success
  end

  test "should create shorten_url" do
    assert_difference('ShortenUrl.count') do
      post shorten_urls_url, params: { shorten_url: { category: @shorten_url.category, click_count: @shorten_url.click_count, created_at: @shorten_url.created_at, expires_at: @shorten_url.expires_at, owner_id: @shorten_url.owner_id, owner_type: @shorten_url.owner_type, unique_key: @shorten_url.unique_key, updated_at: @shorten_url.updated_at, url: @shorten_url.url } }
    end

    assert_redirected_to shorten_url_url(ShortenUrl.last)
  end

  test "should show shorten_url" do
    get shorten_url_url(@shorten_url)
    assert_response :success
  end

  test "should get edit" do
    get edit_shorten_url_url(@shorten_url)
    assert_response :success
  end

  test "should update shorten_url" do
    patch shorten_url_url(@shorten_url), params: { shorten_url: { category: @shorten_url.category, click_count: @shorten_url.click_count, created_at: @shorten_url.created_at, expires_at: @shorten_url.expires_at, owner_id: @shorten_url.owner_id, owner_type: @shorten_url.owner_type, unique_key: @shorten_url.unique_key, updated_at: @shorten_url.updated_at, url: @shorten_url.url } }
    assert_redirected_to shorten_url_url(@shorten_url)
  end

  test "should destroy shorten_url" do
    assert_difference('ShortenUrl.count', -1) do
      delete shorten_url_url(@shorten_url)
    end

    assert_redirected_to shorten_urls_url
  end
end
