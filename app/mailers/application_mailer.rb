class ApplicationMailer < ActionMailer::Base

  default from: "OpenSit <#{ENV.fetch("PUBLIC_EMAIL")}>"

end
