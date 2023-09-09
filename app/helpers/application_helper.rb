module ApplicationHelper

  def avatar_for(person, size: 'h-12 w-12', bg_color: 'bg-stone-500 dark:bg-stone-400', text_color: 'text-white dark:text-stone-800')
    content_tag :span, class: "inline-flex #{size} items-center justify-center rounded-full #{bg_color}" do
      content_tag :span, person.name.initials, class: "text-xl font-medium leading-none #{text_color}"
    end
  end

  def badge_tag(content, extra_classes: '')
    base_classes = "h-8 w-8 inline-flex items-center justify-center rounded-full bg-emerald-700 px-1.5 py-0.5 font-semibold text-white dark:bg-emerald-400 dark:text-stone-800"
    combined_classes = [base_classes, extra_classes].join(' ')
    content_tag :span, content, class: combined_classes
  end

  def stamp_tag(content, extra_classes: '')
    base_classes = "bg-green-700 px-1.5 py-0.5 font-semibold text-white dark:bg-green-400 dark:text-stone-800"
    combined_classes = [base_classes, extra_classes].join(' ')
    content_tag :span, content, class: combined_classes
  end
end
