# Metal Archives Web Service Wrapper

## Installation

```shell
$ gem install metal_archives
```

or add it to your Gemfile

```ruby
gem 'metal_archives'
```

```shell
$ bundle install
```

## Configuration

```ruby
require 'active_support/cache'

MetalArchives.configure do |c|
  # Application identity (required)
  c.app_name = "My App"
  c.app_version = "1.0"
  c.app_contact = "support@mymusicapp.com"

  # Cache config (optional)
  c.enable_cache = true
  c.cache_store = ActiveSupport::Cache.lookup_store(:file_store, '/tmp/metal_archives-cache')

  # Request throttling (optional, overrides defaults)
  c.request_rate = 1
  c.request_timeout = 3

  # Custom logger (optional)
  c.logger = Logger.new File.new('metal_archives.log')
end
```

## Usage

```ruby
require 'metal_archives'

# Search for bands
@alquimia_list = MetalArchives::Band.search('Alquimia')

# Find bands by name
@iron_maiden = MetalArchives::Band.find_by(:name => 'Iron Maiden')

# Find bands by attributes
require 'countries'

@bands_in_belgium = MetalArchives::Band.search_by :country => ISO3166::Country['BE']
@bands_formed_in_1990 = MetalArchives::Band.search_by :year => Range.new(Date.new(1990))

# Metal Archives' usual tips apply

@bands_containing_hell = MetalArchives::Band.search_by :name => '*hell*'
@non_melodic_death_bands = MetalArchives::Band.search_by :genre => 'death -melodic'

# Methods returning multiple results return a MetalArchives::Collection.
# Collection wraps a paginated resource, and can be used to iterate over huge queries.
@non_melodic_death_bands.first(100).each do |band|
  puts band.name
end
```

Refer to the model's [RDoc documentation](https://floriandejonckheere.github.io/metal_archives/html/).

## Debugging

Turn on `debug` in the configuration block to enable logging HTTP requests and responses.

```
$ irb -r metal_archives
```

## Testing
```
$ bundle exec rake test
```

## Documentation
```
$ bundle exec rake rdoc
```

## Copyright

Copyright 2016 Florian Dejonckheere. All content acquired through the usage of this API is copyrighted by the respective owner.
