desc "Mass mail, with skip and limit to help with 200 a day limit"
task :mailshot => :environment do

  limit = ARGV.select{|a| a =~ /limit=/}.last
  skip  = ARGV.select{|a| a =~ /skip=/}.last

  if limit
    limit = limit.split("=").last
  else
    limit = 200
  end

  if skip
    skip = skip.split("=").last
  else
    skip = 0
  end

  ActionMailer::Base.default_url_options = { host: ENV.fetch("DOMAIN") }

  ActionMailer::Base.smtp_settings = {
    :address        => ENV.fetch("MAILGUN_SMTP_SERVER"),
    :port           => ENV.fetch("MAILGUN_SMTP_PORT"),
    :authentication => :plain,
    :user_name      => ENV.fetch("MAILGUN_SMTP_USERNAME"),
    :password       => ENV.fetch("MAILGUN_SMTP_PASSWORD"),
    :domain         => ENV.fetch("DOMAIN"),
    :enable_starttls_auto => true
  }
  ActionMailer::Base.delivery_method = :smtp

  count = 0
  query = User.all.order(created_at: :asc).limit(limit).offset(skip)
  query.each do |user|
    UserMailer.calendar_intro_email(user).deliver
    count += 1
    puts "#{count} #{user.display_name} (#{user.email})"
  end
end
