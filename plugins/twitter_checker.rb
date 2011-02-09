twitter_config = YAML.load_file(File.join(File.dirname(__FILE__), '../config/twitter.yml'))
Twitter.configure do |config|
  config.consumer_key       = twitter_config[:consumer_key]
  config.consumer_secret    = twitter_config[:consumer_secret]
  config.oauth_token        = twitter_config[:oauth_tken]
  config.oauth_token_secret = twitter_config[:oauth_token_secret]
end

class TwitterChecker
  include Cinch::Plugin
  plugin "twitter-checker"

  def initialize(*args)
    super
    @tweets = []
  end

  timer 500, :method => :check_tag
  # match "nyruby"
  def check_tag
    results = Twitter::Search.new.containing("#nyruby").result_type("recent").per_page(10).fetch
    messages = results.map {|tweet| "#{tweet.from_user}: #{tweet.text}"}
    diff = messages - @tweets
    if diff.any?
      @tweets = messages
      diff.each do |message|
        Channel("#nyruby-labs").send message
      end
    else
      # Channel("#nyruby-labs").send "no new tweets"
    end
  end

  # def execute(m)
  #   check_tag
  # end
end
