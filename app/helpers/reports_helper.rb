module ReportsHelper

  def report_reason_options()
    [
      t('report.options.offensive_post'),
      t('report.options.personal_details'),
      t('report.options.offensive_comments'),
      t('report.options.other')
    ]
  end

end
