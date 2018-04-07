# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.2'

# Add additional assets to the asset load path
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "fonts")
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "plugins")

Rails.application.config.assets.precompile += [
  # "manifest.js"
  "application.css",
  "application.js",
  "bootstrap-customized.css",
  "vendor.js",
  "vendor.css"
]
