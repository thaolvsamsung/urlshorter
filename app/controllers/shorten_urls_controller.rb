class ShortenUrlsController < ApplicationController
  before_action :set_shorten_url, only: %i[ edit update destroy ]

  # GET /shorten_urls or /shorten_urls.json
  def index
    results = ShortenUrl.where(owner: current_user[:id]).order('created_at DESC')
    per_page = Rails.application.config.shorten_url.per_page
    @shorten_urls = Kaminari::paginate_array(results).page(params[:page]).per(per_page)
  end

  # GET /shorten_urls/1 or /shorten_urls/1.json
  def show
    token = ShortenUrl.extract_token(params[:id])
    track = Rails.application.config.shorten_url.ignore_robots.blank? || request.human?
    url   = ShortenUrl.fetch_with_token(token: token, additional_params: params, track: track)
    redirect_to url[:url], status: :moved_permanently
  end

  # GET /shorten_urls/new
  def new
    @shorten_url = ShortenUrl.new
  end

  # GET /shorten_urls/1/edit
  def edit
  end

  # POST /shorten_urls or /shorten_urls.json
  def create
    @shorten_url = ShortenUrl.new(shorten_url_params)
    respond_to do |format|
      if @shorten_url.valid? && ShortenUrl.generate!(@shorten_url, current_user)
        format.html { redirect_to shorten_urls_url, notice: "Shorten url was successfully created." }
        format.json { render :show, status: :created, location: @shorten_url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shorten_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shorten_urls/1 or /shorten_urls/1.json
  def update
    respond_to do |format|
      if @shorten_url.update(shorten_url_params)
        format.html { redirect_to shorten_urls_url, notice: "Shorten url was successfully updated." }
        format.json { render :show, status: :ok, location: @shorten_url }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shorten_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shorten_urls/1 or /shorten_urls/1.json
  def destroy
    @shorten_url.destroy

    respond_to do |format|
      format.html { redirect_to shorten_urls_url, notice: "Shorten url was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shorten_url
      token = ShortenUrl.extract_token(params[:id])
      @shorten_url = ShortenUrl.where(unique_key: token, owner: current_user[:id]).first
    end

    # Only allow a list of trusted parameters through.
    def shorten_url_params
      params.require(:shorten_url).permit(:owner_id, :owner_type, :url, :unique_key, :click_count, :expires_at, :created_at, :updated_at, :category)
    end
end
