# protocol-relative embeds
Onebox::Engine::WhitelistedGenericOnebox.rewrites << "gfycat.com"

# our onebox extensions
require_dependency 'onebox/engine/hummingbird_onebox.rb'
require_dependency 'onebox/engine/twitch_onebox.rb'
require_dependency 'onebox/engine/strawpoll_onebox.rb'
