class DevController < ActionController::Base
  def invite_preview
    @resource = current_user
    render 'devise/mailer/invitation_instructions'
  end
end
