require 'spec_helper'

describe User do
  let(:user) { create(:trial_user) }
  let(:customer) { create(:customer) }
  let(:subscriber_user) { create(:basic_subscription).user }

  describe "save_stripe_customer" do
    it "calls create new stripe customer for non-customer" do
      user.should_receive(:create_new_stripe_customer)
      user.save_stripe_customer.should be_true
    end

    it "calls update existing stripe customer for customer" do
      customer.should_receive(:update_existing_stripe_customer)
      customer.save_stripe_customer.should be_true
    end

    it "returns false if validation(s) fail" do
      user.should_receive(:valid_credit_card?).and_return(false)
      user.save_stripe_customer.should be_false
    end
  end

  describe "create_new_stripe_customer" do
    pending "mocking Stipe::Customer"
  end

  describe "update_existing_stripe_customer" do
    pending "mocking Stipe::Customer"
  end

  describe "delete_stripe_customer" do
    it "is called on destroy when user has stripe_customer_token" do
      customer.should_receive(:delete_stripe_customer)
      customer.destroy
    end
  end

  describe "customer?" do
    it "returns true if the user has added billing info to stripe" do
      customer.customer?.should be_true
      subscriber_user.customer?.should be_true
    end

    it "returns false if not a stripe customer" do
      user.customer?.should be_false
    end
  end

  describe "subscriber?" do
    it "returns true if the user has a subscriber" do
      subscriber_user.subscriber?.should be_true
    end

    it "returns false if the user does not have a subscriber" do
      user.subscriber?.should be_false
    end
  end

  describe "trial_user?" do
    context "user less than 30 days old" do
      it "returns true" do
        user.trial_user?.should be_true
      end
    end
    context "user older than 30 days old" do
      it "returns false" do
        user.stub(:created_at).and_return(31.days.ago)
        user.trial_user?.should be_false
      end
    end
  end
end
