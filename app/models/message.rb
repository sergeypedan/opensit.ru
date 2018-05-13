class Message < ActiveRecord::Base

  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user,   class_name: 'User'

  # attr_accessor :body, :subject, :from_user_id, :to_user_id, :read

  validates :body, :from_user_id, :to_user_id, presence: true

  scope :unread, -> { where(read: false) }
  scope :newest_first, -> { order(created_at: :desc) }

  ##
  # VIRTUAL ATTRIBUTES
  ##

  def received_at
    created_at.strftime("%l:%M%P, %d %B %Y")
  end

  ##
  # METHODS
  ##

  def mark_as_read
    self.read = true
    self.save
  end
end
# == Schema Information
#
# Table name: messages
#
#  id               :integer          not null, primary key
#  subject          :string
#  body             :text
#  from_user_id     :integer
#  to_user_id       :integer
#  read             :boolean          default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#  sender_deleted   :boolean          default(FALSE)
#  receiver_deleted :boolean          default(FALSE)
#

#
