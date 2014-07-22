Goodreads.configure(
  :api_key => Rails.application.secrets.omniauth_provider_key,
  :api_secret => Rails.application.secrets.omniauth_provider_secret
)
