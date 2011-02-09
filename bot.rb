require 'bundler/setup'
Bundler.require(:default)

Dir['./plugins/*.rb'].each {|f| require f}

twitter_config = YAML.load_file('./twitter.yml')
Twitter.configure do |config|
  config.consumer_key       = twitter_config[:consumer_key]
  config.consumer_secret    = twitter_config[:consumer_secret]
  config.oauth_token        = twitter_config[:oauth_tken]
  config.oauth_token_secret = twitter_config[:oauth_token_secret]
end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick    = "WNYRuby"
    c.server  = "irc.freenode.net"
    c.port    = 6667
    c.realname = 'WNY RUG'
    c.verbose  = true
    c.version  = 'WNYRUG 0.1' 
    c.channels = ["#nyruby-labs"]
    c.plugins.plugins = [Meetup, TwitterChecker]
  end
end

bot.start
