class Api::PaymentWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_webhook_signature

  def stripe
    event = JSON.parse(request.body.read)

    case event["type"]
    when "checkout.session.completed"
      handle_stripe_success(event["data"]["object"])
    when "checkout.session.expired"
      handle_stripe_failure(event["data"]["object"])
    end

    head :ok
  end

  def paypal
    # PayPal IPN verification and handling
    payment_data = JSON.parse(request.body.read)

    if verify_paypal_ipn(payment_data)
      handle_paypal_success(payment_data)
    else
      handle_paypal_failure(payment_data)
    end

    head :ok
  end

  def mpesa
    # M-Pesa callback handling
    callback_data = JSON.parse(request.body.read)

    if callback_data["Body"]["stkCallback"]["ResultCode"] == 0
      handle_mpesa_success(callback_data)
    else
      handle_mpesa_failure(callback_data)
    end

    head :ok
  end

  private

  def verify_webhook_signature
    # Implement webhook signature verification for each provider
    case action_name
    when "stripe"
      verify_stripe_signature
    when "paypal"
      verify_paypal_signature
    when "mpesa"
      verify_mpesa_signature
    end
  end

  def verify_stripe_signature
    # Stripe webhook signature verification
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

    begin
      # Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      true
    rescue
      head :bad_request and return
    end
  end

  def verify_paypal_signature
    # PayPal IPN verification logic
    true
  end

  def verify_mpesa_signature
    # M-Pesa callback verification logic
    true
  end

  def handle_stripe_success(session)
    payment_id = session["metadata"]["payment_id"]
    payment = Payment.find(payment_id)

    payment.update!(
      status: :completed,
      transaction_id: session["payment_intent"],
      paid_at: Time.current,
      metadata: session
    )

    PaymentProcessingJob.perform_later(payment.id)
  end

  def handle_stripe_failure(session)
    payment_id = session["metadata"]["payment_id"]
    payment = Payment.find(payment_id)

    payment.update!(
      status: :failed,
      metadata: session
    )
  end

  def handle_paypal_success(data)
    payment_id = data["custom"]
    payment = Payment.find(payment_id)

    payment.update!(
      status: :completed,
      transaction_id: data["txn_id"],
      paid_at: Time.current,
      metadata: data
    )

    PaymentProcessingJob.perform_later(payment.id)
  end

  def handle_paypal_failure(data)
    payment_id = data["custom"]
    payment = Payment.find(payment_id)

    payment.update!(
      status: :failed,
      metadata: data
    )
  end

  def handle_mpesa_success(data)
    checkout_request_id = data["Body"]["stkCallback"]["CheckoutRequestID"]
    payment = Payment.find_by(transaction_id: checkout_request_id)

    return unless payment

    payment.update!(
      status: :completed,
      paid_at: Time.current,
      metadata: data
    )

    PaymentProcessingJob.perform_later(payment.id)
  end

  def handle_mpesa_failure(data)
    checkout_request_id = data["Body"]["stkCallback"]["CheckoutRequestID"]
    payment = Payment.find_by(transaction_id: checkout_request_id)

    return unless payment

    payment.update!(
      status: :failed,
      metadata: data
    )
  end
end
