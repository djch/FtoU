module ApplicationHelper

  def avatar_for(person, size: 'h-12 w-12', text_color: 'text-white dark:text-stone-950', color: false)
    #  <%= avatar_for(@customer) %> || <%= avatar_for(@person, color: true) %>
    if color
      colors = [
        'bg-lime-600 dark:bg-lime-400',
        'bg-blue-600 dark:bg-blue-400',
        'bg-teal-600 dark:bg-teal-400',
        'bg-rose-600 dark:bg-rose-400',
        'bg-violet-600 dark:bg-violet-400',
        'bg-purple-600 dark:bg-purple-400',
        'bg-sky-600 dark:bg-sky-400',
        'bg-emerald-600 dark:bg-emerald-400',
        'bg-amber-600 dark:bg-amber-400',
      ]
      initials = person.name.initials
      bg_color = colors[initials.sum % colors.length]
    else
      bg_color = 'bg-stone-500 dark:bg-stone-400'
    end

    content_tag :span, class: "inline-flex #{size} items-center justify-center rounded-full #{bg_color}" do
      content_tag :span, person.name.initials, class: "text-xl font-medium leading-none #{text_color}"
    end
  end

  def badge_tag(content, extra_classes: '')
    base_classes = "h-8 w-8 inline-flex items-center justify-center rounded-full bg-emerald-700 px-1.5 py-0.5 font-semibold tracking-tighter text-white dark:bg-emerald-400 dark:text-stone-800"
    combined_classes = [extra_classes, base_classes].join(' ')
    content_tag :span, content, class: combined_classes
  end

  def stamp_tag(content, extra_classes: '')
    base_classes = "bg-green-700 px-1.5 py-0.5 font-semibold text-white dark:bg-green-400 dark:text-stone-800"
    combined_classes = [base_classes, extra_classes].join(' ')
    content_tag :span, content, class: combined_classes
  end

  def responsive_image_tag(image_name, variant_sizes, html_options = {})
    # Generate srcset
    srcset = variant_sizes.flat_map do |_, variant|
      normal_res = "#{content.image_url(image_name, variant)} #{variant[:resize_to_fill].first / 2}w"
      high_res = "#{content.image_url(image_name, variant)} #{variant[:resize_to_fill].first}w 2x"
      [normal_res, high_res]
    end.join(', ')

    content.image_tag(image_name, {}, html_options.merge({srcset: srcset}))
  end
end
