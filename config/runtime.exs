import Config

unless Mix.env() == :prod do
  Dotenv.load!()
end

config :rauversion, :app_name, System.get_env("APP_NAME", "rauversion")

config :active_storage, :services,
  amazon: [
    service: "S3",
    bucket: System.get_env("AWS_S3_BUCKET"),
    access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
    secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
    region: System.get_env("AWS_S3_REGION"),
    # scheme: "https://",
    # host: "localhost",
    # port: 9000,
    force_path_style: true
  ],
  minio: [
    service: "S3",
    bucket: "active-storage-test",
    access_key_id: "root",
    secret_access_key: "active_storage_test",
    scheme: "http://",
    host: "localhost",
    port: 9000,
    force_path_style: true
  ],
  local: [service: "Disk", root: Path.join(File.cwd!(), "tmp/storage")],
  local_public: [service: "Disk", root: Path.join(File.cwd!(), "tmp/storage"), public: true],
  test: [
    service: "Disk",
    root: "tmp/storage"
  ]

config :rauversion_extension, google_maps_key: System.get_env("GOOGLE_MAPS_KEY")

config :rauversion_extension, disabled_registrations: System.get_env("DISABLED_REGISTRATIONS", "false")

config :ueberauth, Ueberauth.Strategy.Zoom.OAuth,
  client_id: System.get_env("ZOOM_CLIENT_ID"),
  client_secret: System.get_env("ZOOM_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  client_id: System.get_env("TWITTER_CLIENT_ID"),
  client_secret: System.get_env("TWITTER_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Discord.OAuth,
  client_id: System.get_env("DISCORD_CLIENT_ID"),
  client_secret: System.get_env("DISCORD_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Stripe.OAuth,
  client_id: System.get_env("STRIPE_CLIENT_ID"),
  client_secret: System.get_env("STRIPE_CLIENT_SECRET")

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do

  config :rauversion, :domain, System.get_env("HOST", "https://rauversion.com")


  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :active_storage, :secret_key_base, secret_key_base


else

  config :rauversion, :domain, System.get_env("HOST", "http://localhost:4000")

  config :rauversion_extension, Rauversion.Repo,
    password: System.get_env("POSTGRES_PASSWORD", "postgres")

end
