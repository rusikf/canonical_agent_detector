class CanonicalAgent
  def initialize(url)
    @url = url
  end

  def valid?
    html = HttpAgent.new(@url).html
    parsed_html = Nokogiri::HTML.parse(html)

    parsed_html
      .search('head > link')
      .any? { |link| canonical?(link) }
  end

  private

  attr_reader :url

  def canonical?(link)
    link['rel'] == 'canonical' && same_url?(link['href'])
  end

  def same_url?(parsed_url)
    parsed_uri = parse_url(parsed_url)
    original_uri = parse_url(url)

    parsed_uri.domain == original_uri.domain
  end

  def parse_url(uri)
    Addressable::URI.parse(uri)
  end
end
