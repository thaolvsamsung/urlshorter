class Api::V1::ShortenUrlsController < Api::V1::BaseController
  before_action :current_user, except: :authenticate

  def index
    results = @current_user.shorten_urls.unexpired
    per_page = 3
    links = Kaminari.paginate_array(results).page(params[:page]).per(per_page)
    links.collect! {|item|
      item[:unique_key] = shortlink(item[:unique_key])
      item
    }
    render json: {links: links, current_total: links.count, total_all: results.count, current_page: params[:page] || 1}, status: :ok
  end

  def create
    @shorten_url = ShortenUrl.new(shorten_url_params)
    @shorten_url = ShortenUrl.generate!(@shorten_url, @current_user) if @shorten_url.valid?
    if @shorten_url.present? && @shorten_url.persisted?
      render :create, status: :created
    else
      render json: @shorten_url.errors, status: :unprocessable_entity
    end
  end


  private
  def shorten_url_params
    params.permit(:url, :unique_key)
  end

  def shortlink(token)
    token = token[:unique_key] if token.is_a?(Hash)
    "#{request.base_url}/#{token}"
  end
end
