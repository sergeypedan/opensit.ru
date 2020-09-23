class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :access_message?, :only => [:show, :destroy]

  # GET /messages
  # Inbox
  def index
    @user = current_user
    @messages = @user.messages_received.newest_first.limit(10)

    @title = t('messages.inbox')
    @page_class = 'inbox'
  end

  # GET /messages/1
  def show
    @user = current_user
    @message = Message.find(params[:id])
    @from_user = User.find(@message.from_user_id)
    @reply = Message.new(subject: "RE: " + @message.subject)

    # Only mark as read if the recipient is reading
    @message.mark_as_read unless @user.id == @from_user.id

    @title = t('messages.message_from', username: @from_user.display_name)
    @page_class = "view-message"
  end

  # GET /messages/new
  def new
    @user = current_user
    @message = Message.new
    @title = t('messages.new')
    @page_class = 'new-message'
    html = { multiple: false, data: { placeholder: t('messages.choose_user')}, class: 'chosen-select' }
    @message_options = { label: false, collection: current_user.followed_users, label_method: 'username', input_html: html }
 end

  # GET /messages/sent
  def sent
    @user = current_user
    @messages = @user.messages_sent.newest_first.limit(10)

    @title = t('messages.sent')
    @page_class = 'sent-items'
  end

  # POST /messages
  def create
    @user = current_user

    @message = Message.new(message_params.merge({ from_user_id: @user.id }))

    if !@message.valid?
      render action: "new"
    else
      @message.save!
      redirect_to messages_url, notice: t('messages.message_sent')
    end
  end

  # DELETE /messages/1
  def destroy
    @user = current_user
    @message = Message.find(params[:id])

    if @user.id == @message.from_user_id
      @message.sender_deleted = true
    else
      @message.receiver_deleted = true
    end

    @message.save
    @message.destroy if @message.sender_deleted && @message.receiver_deleted

    redirect_to messages_url
  end

  # Is the current user allowed to view this message?
  def access_message?
    @user = current_user
    @message = Message.find(params[:id])

    return true if (@user.id == @message.from_user_id) or (@user.id == @message.to_user_id)
    redirect_to messages_path
  end

  private

  def message_params
    params.require(:message).permit(:subject, :body, :to_user_id)
  end
end
