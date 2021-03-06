class SubscriptionsController < ApplicationController
  before_filter :authenticate_customer!

  def create
    if current_user.subscription.present?
      @subscription = current_user.subscription
      @subscription.plan_id = params[:plan_id]
    else
      @subscription = current_user.subscriber.build_subscription(plan_id: params[:plan_id], user_id: current_user.id)
    end
    if @subscription.save
      flash[:analytics] = "/vp/add_subscription"
      redirect_to whiteboards_url, notice: "Your subscription plan has been updated."
    else
      redirect_to plans_url, alert: @subscription.errors.full_messages.first
    end
  end

  def destroy
    @subscription = current_user.subscription
    @subscription.destroy
    flash[:analytics] = "/vp/cancel_subscription"
    redirect_to root_url, notice: "Your subscription has been canceled.  Let us know if there is anything we can do to make your Whiteboard experience better."
  end
end