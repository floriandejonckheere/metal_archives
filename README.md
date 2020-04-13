# Metal Archives Ruby API [![Travis](https://travis-ci.org/floriandejonckheere/metal_archives.svg?branch=master)](https://travis-ci.org/floriandejonckheere/metal_archives) [![Coverage Status](https://coveralls.io/repos/github/floriandejonckheere/metal_archives/badge.svg)](https://coveralls.io/github/floriandejonckheere/metal_archives)

MetalArchives is a Ruby API that transparently wraps, caches and normalizes the [Metal Archives](https://www.metal-archives.com) website.

## Installation

Add this line to your application's Gemfile.

```ruby
gem "metal_archives", "0.1.0"
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install metal_archives
```

## Configuration

Configure MetalArchives before using it:

```ruby
MetalArchives.configure do |c|
  ## Application identity (required)
  c.app_name = 'My App'
  c.app_version = '1.0'
  c.app_contact = 'support@mymusicapp.com'

  ## Request throttling (optional, overrides defaults)
  c.request_rate = 1
  c.request_timeout = 3
  
  ## Connect additional Faraday middleware
  # c.middleware = [MyMiddleware, MyOtherMiddleware]

  ## Custom cache size per object class (optional, overrides defaults)
  c.cache_size = 100
  
  ## Metal Archives endpoint (optional, overrides default)
  # c.endpoint = "https://www.metal-archives.com/"
  
  ## Custom logger (optional)
  c.logger = Logger.new File.new('metal_archives.log')
  c.logger.level = Logger::INFO
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

## Lazy loading

By default when an model (Artist, Band, ...) is created, no data is fetched. 
This leads to instantiation of a model with an invalid ID not throwing any errors. 
Calling any attribute other than `id` will cause all data to be fetched and any errors to be thrown. 
Refer to the respective methods to find out what errors are thrown in what circumstances.

Models can be forced to load all data by calling the `:load!` method.  

## Cache

In order not to stress the Metal Archives server, you can quickly set up a local proxy that caches the requests.

```
docker-compose up -d
```

A caching proxy server is now available on `http://localhost/`.

## Testing

Run tests:

```
bundle exec rake test
```

## Documentation

Generate documentation:

```
$ bundle exec rake rdoc
```

## Copyright

Copyright 2016-2020 Florian Dejonckheere.
All content acquired through the usage of this API is copyrighted by the respective owner.
