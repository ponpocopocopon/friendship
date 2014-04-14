### Friendship extension
  add friendship to user model.

## install

write Gemfile.
```
gem 'friendship', github: "ponpocopocopon/friendship"
```

make migration and create db table.
```
rake friendship:install:migrations
rake db:migrate
```

include in user model.
```ruby
  include Friendship::Model
```

add the options as required.
```ruby
include Friendship::Model
# The introduction of the approval system
set_require_friend_recognition
# Allow one-sided relationship
set_possible_unrequited_friend
```

## use

added to the user model the following methods.

Class Methods
```ruby
User.set_require_friend_recognition
User.require_friend_recognition?
User.set_possible_unrequited_friend
User.possible_unrequited_friend?
```

Instance Methods
```ruby
me.send_pending_friends
me.receive_pending_friends
me.allow_friend!(you)
me.deny_friend!(you)
me.friends
me.friend!(you)
me.unfriend!(you)
me.friend?(you)
me.friend_by?(you)
```
