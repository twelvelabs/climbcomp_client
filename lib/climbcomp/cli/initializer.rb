# frozen_string_literal: true

Climbcomp.configure do |c|
  # TODO: remove once we've setup a production server
  c.oidc_audience = 'https://staging.climbcomp.com/'

  # Set the token options from the stored token (if one exists)
  ts = Climbcomp::OAuth2::TokenStore.new(c.token_store_path)
  c.token = ts.retrieve
end
