module ApplicationHelper

  def avatar_for(person, size: 'h-12 w-12', bg_color: 'bg-stone-500', text_color: 'text-white')
    content_tag :span, class: "inline-flex #{size} items-center justify-center rounded-full #{bg_color}" do
      content_tag :span, person.name.initials, class: "text-xl font-medium leading-none #{text_color}"
    end
  end
end
