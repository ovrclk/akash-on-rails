module ApplicationHelper
  def errors_for(object)
    if object.errors.any?
      content_tag(:div, class: 'card text-white bg-danger mb-3') do
        concat(content_tag(:div, class: 'card-header') do
          concat(content_tag(:h5) do
            concat "#{pluralize(object.errors.count, 'error')} prohibited this #{object.class.name.downcase} from being saved:"
          end)
        end)
        concat(content_tag(:div, class: 'card-body') do
          concat(content_tag(:ul) do
            object.errors.full_messages.each do |msg|
              concat content_tag(:li, msg)
            end
          end)
        end)
      end
    end
  end
end
