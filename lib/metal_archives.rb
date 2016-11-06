require 'metal_archives/version'
require 'metal_archives/configuration'
require 'metal_archives/error'

require 'metal_archives/models/base_model'
require 'metal_archives/models/range'
require 'metal_archives/models/label'
require 'metal_archives/models/band'

require 'metal_archives/clients/base_client'
require 'metal_archives/clients/band'

require 'metal_archives/parsers/parser_helper'
require 'metal_archives/parsers/band'
require 'metal_archives/parsers/label'

require 'metal_archives/http_client'

##
# Metal Archives Web Service Ruby API wrapper
#
module MetalArchives
end
