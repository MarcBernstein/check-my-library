Rails.application.config.middleware.use OmniAuth::Builder do
  provider :goodreads, Rails.application.secrets.omniauth_provider_key, Rails.application.secrets.omniauth_provider_secret
end