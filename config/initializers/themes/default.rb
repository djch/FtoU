# Theme configuration file
# ========================
# This file is used for all theme configuration.
# It's where you define everything that's editable in Spina CMS.

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
    # Homepage
    {name: "hero", title: "Hero", hint: "The big photo at the top",  part_type: "Spina::Parts::Image"},
    {name: "headline", title: "Headline", hint: "Big title text over hero image",  part_type: "Spina::Parts::Line"},
    {name: "subhead", title: "Subheadline", hint: "Optional smaller text under the title",  part_type: "Spina::Parts::MultiLine"},
    # Pages
    {name: "text", title: "Body", hint: "Main text content", part_type: "Spina::Parts::Text"},
    # Strips
    # A repeating element for the homepage
    { name: "heading", title: "Heading", part_type: "Spina::Parts::Line" },
    { name: "image", title: "Image", part_type: "Spina::Parts::Image" },
    {
      name: "strips",
      title: "Strips",
      parts: %w(heading text image),
      part_type: "Spina::Parts::Repeater",
    },
  ]

  # View templates
  # Every page has a view template stored in app/views/my_theme/pages/*
  # You define which parts you want to enable for every view template
  # by referencing them from the theme.parts configuration above.
  theme.view_templates = [
    {name: "homepage", title: "Homepage", parts: %w[hero headline subhead strips]},
    {name: "show", title: "Page", parts: %w[text]}
  ]

  # Custom pages
  # Some pages should not be created by the user, but generated automatically.
  # By naming them you can reference them in your code.
  theme.custom_pages = [
    {name: "homepage", title: "Homepage", deletable: false, view_template: "homepage"}
  ]

  # Navigations (optional)
  # If your project has multiple navigations, it can be useful to configure multiple
  # navigations.
  theme.navigations = [
    {name: "main", label: "Main navigation"}
  ]

  # Layout parts (optional)
  # You can create global content that doesn't belong to one specific page. We call these layout parts.
  # You only have to reference the name of the parts you want to have here.
  theme.layout_parts = []

  # Resources (optional)
  # Think of resources as a collection of pages. They are managed separately in Spina
  # allowing you to separate these pages from the 'main' collection of pages.
  theme.resources = []

  # Plugins (optional)
  theme.plugins = []

  # Embeds (optional)
  theme.embeds = []
end
