import Config


# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :rauversion_extension, RauversionWeb.Endpoint,
#       ...,
#       url: [host: "example.com", port: 443],
#       https: [
#         ...,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :rauversion_extension, RauversionWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.

config :rauversion_extension, Oban,
  repo: Rauversion.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, events: 50, media: 20],
  notifier: Oban.Notifiers.PG,
  peer: Oban.Peers.Global

config :active_storage, :host, "https://rauversion.com"
config :active_storage, :service, :amazon
# config :active_storage, :secret_key_base, "xxxxxxxxxxx"
config :active_job, repo: Rauversion.Repo
config :active_storage, repo: Rauversion.Repo

config :mogrify,
  mogrify_command: [
    path: "mogrify",
    args: []
  ]

# Configure convert command:

config :mogrify,
  convert_command: [
    path: "convert",
    args: []
  ]

# Configure identify command:

config :mogrify,
  identify_command: [
    path: "identify",
    args: ["-verbose"]
  ]
