# This module monkeypath paperclip, for faster url generation
# https://github.com/thoughtbot/paperclip/issues/909
# https://github.com/thoughtbot/paperclip/pull/916

module Paperclip
  module Interpolations
    def self.interpolate(pattern, *args)
      pattern.gsub /:([[:word:]]+)/ do
        Paperclip::Interpolations.respond_to?($1) ? Paperclip::Interpolations.send($1, *args) : ":#{$1}"
      end
    end
  end
end