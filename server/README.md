# Hummingbird Server

This README outlines the details of collaborating on this application.

## Styleguide

* [Ruby](https://github.com/bbatsov/ruby-style-guide)
* [Rails](https://github.com/bbatsov/rails-style-guide) - - [Amendments](https://github.com/hummingbird-me/hummingbird/blob/the-future/server/README.md#rails)

## Styleguide Amendments

These amendments are listed below, though we may forget some. Rubocop will help
you, and we have a `.rubocop.yml` which we develop with.

### Rails
#### ActiveRecord Models
 * Group macro-style methods at the beginning of the class definition, in the
   following order:

   ```ruby
   class User < ActiveRecord::Base
     # put the default scope at the top
     default_scope { includes(:favorites) }

     # then the constants
     COLORS = %w[red green blue]

     # then named scopes
     scope(:banned) { where(banned: true) }

     # then any mixin-style "acts_as_*" and similar methods
     acts_as_sortable
     devise :database_authenticable, :registerable, :recoverable,
            :validatable, :confirmable

     # then field-type macros such as enum or has_attached_file
     enum rating_system: %i[smilies stars]
     has_attached_file :avatar

     # then associations
     has_many :library_entries

     # then validation
     validates :email, presence: true
     validates name, presence: true

     # and then callbacks
     before_save :do_the_thing

     # ... and finally the rest of the methods!
   end
   ```
