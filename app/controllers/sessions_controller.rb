class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # Log the user and redirect to the user's show page
      reset_session
      log_in user
      redirect_to user
    else
      # Create an error message
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
