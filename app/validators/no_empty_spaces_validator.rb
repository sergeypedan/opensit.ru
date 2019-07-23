class NoEmptySpacesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, I18n.t('errors.messages.no_empty_spaces')) if value.match(/\s+/)
  end
end
