# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
Rails.application.config.assets.paths << 'vendor/assets/plugins'

Rails.application.config.assets.precompile += [
  # "manifest.js"
  "application.css",
  "application.js",
  "bootstrap-customized.css",
  "vendor.css",

  # "mail/common.css",
  # "mail/previewer.css",

  # "vendor-front.js",
  # "initializers.js",

  # "admin.css",
  # "bootstrap-back.css",
  # "admin.js",
  # "vendor-back.css",
  # "vendor-back.js",
  # "initializersback.js",


  # "fonts.css",
  # "rouble/stylesheet.scss",
  # "gentium-plus/stylesheet.scss",
  # "bannikova/stylesheet.scss",

  # "admin/purchases.js",
  # "admin/discount-recalculation.js",

  # "product.js",
  # "purchase/submit-states.js",
  # "form-validation.js",

  # "swiper-3.3.0.css",
  # "swiper-3.3.0-jquery.js",

  # "tinymce-body.css"
]
