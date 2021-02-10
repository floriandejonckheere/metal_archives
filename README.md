# Metal Archives Ruby API

![Continuous Integration](https://github.com/floriandejonckheere/metal_archives/workflows/Continuous%20Integration/badge.svg)
![Release](https://img.shields.io/github/v/release/floriandejonckheere/metal_archives?label=Latest%20release)


MetalArchives is a Ruby API that transparently wraps, caches and normalizes the [Metal Archives](https://www.metal-archives.com) website.

## Installation

Add this line to your application's Gemfile.

```ruby
gem "metal_archives"
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
  c.app_name = "My App"
  c.app_version = "1.0"
  c.app_contact = "support@mymusicapp.com"

  ## Enable Redis as caching backend (optional, overrides default memory cache)
  # c.cache_strategy = :redis
  # c.cache_options = { url: "redis://redis:6379", ttl: 1.month.to_i }
  
  ## Metal Archives endpoint (optional, overrides default)
  # c.endpoint = "https://www.metal-archives.com/"
  # c.endpoint_user = "my_user"
  # c.endpoint_password = "my_password"
  
  ## Custom logger (optional)
  c.logger = Logger.new File.new("metal_archives.log")
  c.logger.level = Logger::INFO
end
```

## Usage

```ruby
require "metal_archives"

# Search for bands
@alquimia_list = MetalArchives::Band.search("Alquimia")

# Find bands by name
@iron_maiden = MetalArchives::Band.find_by(:name => "Iron Maiden")

# Find bands by attributes
require "countries"

@bands_in_belgium = MetalArchives::Band.search_by :country => ISO3166::Country["BE"]
@bands_formed_in_1990 = MetalArchives::Band.search_by :year => Range.new(Date.new(1990))

# Metal Archives" usual tips apply

@bands_containing_hell = MetalArchives::Band.search_by :name => "*hell*"
@non_melodic_death_bands = MetalArchives::Band.search_by :genre => "death -melodic"

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

Models can be forced to load all data by calling the `load!` method.  

## Cache

The gem has builtin caching functionality.
By default, an in-memory cache is used that evicts cache entries using an LRU-based algorithm.
However, it is also possible to use Redis as a caching backend.
Don't forget to include the `redis` gem in your application bundle if you wish to use Redis caching.

In order not to stress the Metal Archives server, you can quickly set up a local HTTP proxy that caches the requests.

```
# Generate TLS client certificates for NGINX
openssl req -nodes -new -x509  -keyout nginx/client.key -out nginx/client.pem


# Start proxy server
docker-compose up -d
```

A caching proxy server is now available on `http://localhost:8080/`.

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

## License

See [LICENSE.md](LICENSE.md).
