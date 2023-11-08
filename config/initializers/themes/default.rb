# Theme configuration file
# ========================
# This file is used for all theme configuration.
# It's where you define everything that's editable in Spina CMS.

Rails.application.reloader.to_prepare do
  Spina::Part.register(Spina::Parts::AvailableProducts)
end

Spina::Theme.register do |theme|
  # All views are namespaced based on the theme's name
  theme.name = "default"
  theme.title = "Default theme"

  # Parts
  # Define all editable parts you want to use in your view templates
  #
  # Built-in part types:
  # - Line
  # - MultiLine
  # - Text (Rich text editor)
  # - Image
  # - ImageCollection
  # - Attachment
  # - Option
  # - Repeater
  theme.parts = [
    # Layout parts
    {name: "about", title: "About blurb", hint: "Short intro of the company", part_type: "Spina::Parts::Text"},
    {name: "abn", title: "ABN", hint: "The company ABN for displayed in the site footer", part_type: "Spina::Parts::Line"},
    {name: "hours", title: "Operating hours", hint: "Typical opening hours of the business", part_type: "Spina::Parts::MultiLine"},
    {name: "facebook", title: "Facebook URL", hint: "Link to the company Facebook page", part_type:  "Spina::Parts::Line"},
    # Homepage
    {name: "hero", title: "Hero Image", hint: "The big photo at the top",  part_type: "Spina::Parts::Image"},
    {name: "headline", title: "Headline", hint: "Big title text over hero image",  part_type: "Spina::Parts::Line"},
    {name: "subhead", title: "Subheadline", hint: "Optional smaller text under the title",  part_type: "Spina::Parts::MultiLine"},
    # Pages
    {name: "text", title: "Body", hint: "Main text content", part_type: "Spina::Parts::Text"},
    {name: "available_products", title: "Available Products", hint: "", part_type: "Spina::Parts::AvailableProducts"},
    {name: "gallery", title: "Gallery", hint: "Optional gallery of company imagery", part_type: "Spina::Parts::ImageCollection"},
    # Strips — a repeating prose element for the homepage
    { name: "heading", title: "Heading", part_type: "Spina::Parts::Line" },
    { name: "image", title: "Foreground Image", hint: "Displayed next to text", part_type: "Spina::Parts::Image" },
    {
      name: "bg_image",
      title: "Background Image",
      hint: "Displayed behind text and foreground image",
      part_type: "Spina::Parts::Image",
    },
    {
      name: "strips",
      title: "Strips",
      parts: %w(heading text image bg_image),
      part_type: "Spina::Parts::Repeater",
    },
    # Testimonials — horizontal scrolling strip for the homepage
    #
    # Directions – a specific strip for showing the address and map etc.
    #
  ]

  # View templates
  # Every page has a view template stored in app/views/my_theme/pages/*
  # You define which parts you want to enable for every view template
  # by referencing them from the theme.parts configuration above.
  theme.view_templates = [
    { name: "homepage", title: "Homepage", parts: %w[hero headline subhead strips] },
    { name: "products", title: "Product page", parts: %w[text available_products] },
    { name: "show", title: "Page", parts: %w[text gallery] }
  ]

  # Custom pages
  # Some pages should not be created by the user, but generated automatically.
  # By naming them you can reference them in your code.
  theme.custom_pages = [
    { name: "homepage", title: "Homepage", deletable: false, view_template: "homepage" },
    { name: "products", title: "Products page", deletable: true, view_template: "products" },
  ]

  # Navigations (optional)
  # If your project has multiple navigations, it can be useful to configure multiple
  # navigations.
  theme.navigations = [
    { name: "main", label: "Main navigation" },
    # { name: "footer", label: "Footer links" }
  ]

  # Layout parts (optional)
  # You can create global content that doesn't belong to one specific page. We call these layout parts.
  # You only have to reference the name of the parts you want to have here.
  theme.layout_parts = %w(about abn hours facebook)

  # Resources (optional)
  # Think of resources as a collection of pages. They are managed separately in Spina
  # allowing you to separate these pages from the 'main' collection of pages.
  theme.resources = []

  # Plugins (optional)
  theme.plugins = []

  # Embeds (optional)
  theme.embeds = %w(button)
end
