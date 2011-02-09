require 'cinch'
require 'open-uri'
require 'simple-rss'

class WnyGroup
  include Cinch::Plugin
  plugin "wnygroup"
  help "!wnyrug"

  match /wnyrug/

  def initialize(*args)
    super
    @latest = ""
  end

  timer 10, method: :fetch_latest
  def fetch_latest
    rss = SimpleRSS.parse(open("http://www.meetup.com/Western-New-York-Ruby/events/rss/WNY+-+Buffalo+Ruby/"))
    if latest = rss.entries.first
      title, link = latest[:title], latest[:guid]
      attending = latest[:description].scan(/Attending:\s+(\d+)/).flatten.first
      string = "#{title} [#{attending || 0}] (#{link})"
      if string != @latest
        @latest = string
        Channel("#nyruby-labs").send @latest
      end
    end
  end
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
    c.plugins.plugins = [WnyGroup]
  end

  on :message, /Hello/ do |m|
    m.reply "hello"
  end
end

bot.start