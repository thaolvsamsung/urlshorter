class ShortenUrl < ApplicationRecord
  belongs_to :owner, polymorphic: true, optional: true

  REGEX_LINK_HAS_PROTOCOL = Regexp.new('\Ahttp:\/\/|\Ahttps:\/\/', Regexp::IGNORECASE)
  URL_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\Z/ix
  CHARSETS = {
    alphanum: ('a'..'z').to_a + (0..9).to_a,
    alphanumcase: ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
  }
  validates :url, presence: true, format: URL_REGEX
  validates :unique_key, uniqueness: true
  around_create :generate_unique_key

  scope :unexpired, -> { where(arel_table[:expires_at].eq(nil).or(arel_table[:expires_at].gt(::Time.current))) }

  attr_accessor :custom_key, :short_url

  # ensure the url starts with it protocol and is normalized
  def self.clean_url(url)
    url = url.to_s.strip
    if url !~ REGEX_LINK_HAS_PROTOCOL && url[0] != '/'
      url = "http://#{url}"
    end
    URI.parse(url).normalize.to_s
  end

  def self.generate!(destination_url, owner, custom_key: nil, expires_at: nil, fresh: false, category: nil)
    if destination_url.is_a? ShortenUrl
      if destination_url.owner == owner && destination_url.id.present?
        destination_url
      else
        generate!(
          destination_url.url,
          owner:      owner,
          custom_key: custom_key,
          expires_at: expires_at,
          fresh:      fresh,
          category:   category
        )
      end
    else

      scope = if owner
        owner = User.find(owner[:owner][:id])
        owner.shorten_urls
      else
        self
      end
      creation_method = fresh ? 'create' : 'first_or_create'

      url_to_save = Rails.application.config.shorten_url.auto_clean_url ? clean_url(destination_url) : destination_url
      scope.where(url: url_to_save, category: category).send(
        creation_method,
        custom_key: custom_key,
        expires_at: expires_at
      )
    end
  end

  def self.generate(destination_url, owner, custom_key: nil, expires_at: nil, fresh: false, category: nil)
    begin
      generate!(
        destination_url,
        owner: owner,
        custom_key: custom_key,
        expires_at: expires_at,
        fresh: fresh,
        category: category
      )
    rescue => e
      logger.info e
      nil
    end
  end

  def self.extract_token(token_str)
    /^([#{Regexp.escape(key_chars.join)}]*).*/.match(token_str)[1]
  end

  def self.fetch_with_token(token: nil, additional_params: {}, track: true)
    shortened_url = ShortenUrl.unexpired.where(unique_key: token).first

    url = if shortened_url
      shortened_url.increment_usage_count if track
      merge_params_to_url(url: shortened_url.url, params: additional_params)
    else
      Rails.application.config.shorten_url.default_redirect || '/'
    end

    { url: url, shortened_url: shortened_url }
  end

  def self.merge_params_to_url(url: nil, params: {})
    if params.respond_to?(:permit!)
      params = params.permit!.to_h.with_indifferent_access.except!(:id, :action, :controller)
    end

    if Rails.application.config.shorten_url.subdomain
      params.try(:except!, :subdomain) if params[:subdomain] == Rails.application.config.shorten_url.subdomain
    end

    if params.present?
      uri = URI.parse(url)
      existing_params = Rack::Utils.parse_nested_query(uri.query)
      uri.query       = existing_params.with_indifferent_access.merge(params).to_query
      url = uri.to_s
    end

    url
  end

  def increment_usage_count
    self.class.increment_counter(:click_count, id)
  end

  def to_param
    unique_key
  end

  private

  def self.unique_key_candidate
    charset = key_chars
    (0...Rails.application.config.shorten_url.unique_key_length).map{ charset[rand(charset.size)] }.join
  end

  def generate_unique_key(retries = Rails.application.config.shorten_url.persist_retries)
    begin
      self.unique_key = custom_key || self.class.unique_key_candidate
      self.custom_key = nil
    end while self.class.unscoped.exists?(unique_key: unique_key)

    yield
  rescue ActiveRecord::RecordNotUnique
    if retries <= 0
      raise
    else
      retries -= 1
      retry
    end
  end

  def self.key_chars
    charset = Rails.application.config.shorten_url.charset
    charset.is_a?(Symbol) ? CHARSETS[charset] : charset
  end
end
