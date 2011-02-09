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
