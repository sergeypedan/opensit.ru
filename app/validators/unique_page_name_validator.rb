class UniquePageNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.match(/\s+/)
      route = Rails.application.routes.recognize_path("/#{value}")
      if route[:controller] != "user" && route[:action] != "show"
        record.errors.add(attribute, I18n.t('errors.messages.unique_page_name', value))
      end
    end
  end
end
