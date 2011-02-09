class Meetup
  include Cinch::Plugin
  plugin "meetup"
  help "!wnyrug"

  match /wnyrug/

  def initialize(*args)
    super
    @latest = ""
  end

  timer 10, :method => :fetch_latest
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
