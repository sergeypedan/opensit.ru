class ApplicationMailer < ActionMailer::Base

  default from: "OpenSit <#{Rails.application.secrets.public_email}>"

end
