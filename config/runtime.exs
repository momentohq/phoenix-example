import Config

credential_provider = Momento.Auth.CredentialProvider.from_env_var!("MOMENTO_AUTH_TOKEN")
config :momento_example, :momento_credential_provider, credential_provider

if config_env() == :prod do
  config :momento_example, :momento_config, Momento.Configurations.InRegion.Default.latest()
else
  config :momento_example, :momento_config, Momento.Configurations.Laptop.latest()
end
