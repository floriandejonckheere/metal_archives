# Metal Archives Web Service Wrapper

## Installation

```
gem install metal_archives
```

or add it to your Gemfile

```ruby
gem 'metal_archives'
```

## Configuration

```ruby
MetalArchives.configure do |c|
  # Application identity (required)
  c.app_name = "My App"
  c.app_version = "1.0"
  c.app_contact = "support@mymusicapp.com"

  # Cache config (optional)
  c.cache_path = "/tmp/metal_archives-cache"
  c.perform_caching = true

  # Querying config (optional)
  c.query_interval = 1.2 # seconds
  c.tries_limit = 2
end
```

## Usage

```ruby
require 'metal_archives'

# Search for artists
@alquimia_list = MetalArchives::Artist.search("Alquimia")

# Find artist by name
@iron_maiden = MusicBrainz::Artist.find_by_name("Iron Maiden")
```

## Debugging

```
$ irb -r metal_archives
```

## Testing
```
bundle exec rspec
```

## Copyright

Copyright 2016 Florian Dejonckheere. See `LICENSE` for further details.
