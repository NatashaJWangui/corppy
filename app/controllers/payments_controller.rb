class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_registration
  before_action :set_payment, only: [ :show, :callback ]
  def new
    @payment_method = params[:payment_method]
    @payment = @registration.payments.build(
      amount: @registration.total_fees,
      currency: "USD",
      payment_method: @payment_method,
      document: @registration.current_document
    )

    redirect_to step_registration_path(@registration, step: 8) unless @registration.current_document&.signed?
  end

  def create
    @payment = @registration.payments.build(payment_params)
    @payment.document = @registration.current_document
    @payment.amount = @registration.total_fees
    @payment.currency = "USD"

    if @payment.save
      case @payment.payment_method
      when "card"
        redirect_to_stripe_checkout
      when "paypal"
        redirect_to_paypal_checkout
      when "mpesa"
        redirect_to_mpesa_checkout
      when "bank_transfer"
        redirect_to bank_transfer_instructions
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # Payment confirmation page
  end

  def callback
    # Handle payment provider callbacks/webhooks
    case params[:provider]
    when "stripe"
      handle_stripe_callback
    when "paypal"
      handle_paypal_callback
    when "mpesa"
      handle_mpesa_callback
    end
  end

  private

  def set_registration
    @registration = current_user.business_registrations.find(params[:registration_id])
  end

  def set_payment
    @payment = @registration.payments.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:payment_method, :payment_provider)
  end

  def redirect_to_stripe_checkout
    @payment.update!(payment_provider: "stripe")

    # Create Stripe checkout session
    session_url = create_stripe_session
    redirect_to session_url, allow_other_host: true
  end

  def redirect_to_paypal_checkout
    @payment.update!(payment_provider: "paypal")

    # Create PayPal order
    order_url = create_paypal_order
    redirect_to order_url, allow_other_host: true
  end

  def redirect_to_mpesa_checkout
    @payment.update!(payment_provider: "mpesa")
    redirect_to mpesa_payment_path(@payment)
  end

  def create_stripe_session
    # Stripe::Checkout::Session.create would go here
    # Return the checkout URL
    "https://checkout.stripe.com/session_#{@payment.id}"
  end

  def create_paypal_order
    # PayPal order creation would go here
    # Return the approval URL
    "https://paypal.com/checkoutnow?token=#{@payment.id}"
  end

  def handle_stripe_callback
    # Verify Stripe webhook signature and update payment
    @payment.process_payment!
    redirect_to payment_path(@payment)
  end

  def handle_paypal_callback
    # Verify PayPal IPN and update payment
    @payment.process_payment!
    redirect_to payment_path(@payment)
  end

  def handle_mpesa_callback
    # Verify M-Pesa callback and update payment
    @payment.process_payment!
    redirect_to payment_path(@payment)
  end
end
