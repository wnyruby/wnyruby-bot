require 'bundler/setup'
Bundler.require(:default)

plugins = []
Dir['./plugins/*.rb'].each do |f|
  require f
  plugins << Kernel.const_get(File.basename(f, '.rb').split('_').map(&:capitalize).join)
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
    c.plugins.plugins = plugins
  end
end

bot.start
