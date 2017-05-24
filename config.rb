require 'dotenv'

Dotenv.load

activate :search_engine_sitemap
activate :dato, live_reload: true

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

configure :development do
  activate :livereload
end

configure :build do
  activate :asset_hash
  activate :gzip
  # activate :imageoptim # doesn't support MM4 https://github.com/plasticine/middleman-imageoptim/issues/46
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
end

configure :production do
  activate :s3_sync do |s3_sync|
    s3_sync.bucket                     = 'vivafraser.com'
    s3_sync.region                     = 'us-east-1'
    s3_sync.aws_access_key_id          = ENV['AWS_ACCESS_KEY_ID']
    s3_sync.aws_secret_access_key      = ENV['AWS_SECRET_ACCESS_KEY']
    s3_sync.prefix                     = ''
    s3_sync.index_document             = 'index.html'
    # s3_sync.error_document             = '404.html'
  end

  caching_policy 'text/html', max_age: 0, must_revalidate: true
  default_caching_policy max_age:(60 * 60 * 24 * 365)
end

helpers do
  def markdown(source)
    Tilt[:markdown].new { source }.render(self)
  end
end
