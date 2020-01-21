class HttpAgent
  def initialize(url)
    @url = url
  end

  def html
    cache do
      RestClient::Request
        .execute(method: :get, url: url, read_timeout: 5, open_timeout: 5)
        .body
    end
  end

  private

  attr_reader :url

  def cache
    Rails.cache.fetch("http_#{url}", expires_in: 5.minutes) { yield }
  end
end
