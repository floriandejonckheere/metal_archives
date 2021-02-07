# frozen_string_literal: true

WebMock.disable_net_connect!(allow: ENV.fetch("WEBMOCK_ALLOW_HOST", "localhost"))
