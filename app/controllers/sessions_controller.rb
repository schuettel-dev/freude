class SessionsController < ApplicationController
  skip_before_action :authenticate!
  before_action :redirect_if_signed_in, except: :destroy

  def new
    @form = SessionForm.new(params:)
  end

  def create
    @form = SessionForm.new(params:)

    if @form.valid?
      sign_in(@form.user)
      use_after_sign_in_redirect_to_url || redirect_to(root_path)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    redirect_to new_sign_up_path
  end
end
