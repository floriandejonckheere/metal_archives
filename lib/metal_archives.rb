# frozen_string_literal: true

require 'metal_archives/version'
require 'metal_archives/configuration'
require 'metal_archives/error'

require 'metal_archives/utils/range'
require 'metal_archives/utils/collection'
require 'metal_archives/utils/lru_cache'
require 'metal_archives/utils/nil_date'

require 'metal_archives/models/base_model'
require 'metal_archives/models/label'
require 'metal_archives/models/artist'
require 'metal_archives/models/band'

require 'metal_archives/parsers/parser'
require 'metal_archives/parsers/label'
require 'metal_archives/parsers/artist'
require 'metal_archives/parsers/band'

require 'metal_archives/http_client'

##
# Metal Archives Ruby API
#
module MetalArchives
end
