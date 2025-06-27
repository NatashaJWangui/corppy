class Payment < ApplicationRecord
  belongs_to :business_registration
  belongs_to :document

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :payment_method, presence: true
  validates :payment_provider, presence: true

  enum status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3,
    refunded: 4,
    cancelled: 5
  }

  enum payment_method: {
    card: 0,
    bank_transfer: 1,
    paypal: 2,
    mpesa: 3,
    airtel_money: 4
  }

  scope :successful, -> { where(status: :completed) }
  scope :recent, -> { order(created_at: :desc) }

  def formatted_amount
    "$#{amount}"
  end

  def payment_provider_name
    case payment_provider
    when "stripe"
      "Stripe"
    when "paypal"
      "PayPal"
    when "mpesa"
      "M-Pesa"
    when "flutterwave"
      "Flutterwave"
    else
      payment_provider.humanize
    end
  end

  def can_be_refunded?
    completed? && created_at > 30.days.ago
  end

  def process_payment!
    case payment_method
    when "card"
      process_stripe_payment
    when "paypal"
      process_paypal_payment
    when "mpesa"
      process_mpesa_payment
    when "bank_transfer"
      process_bank_transfer
    end
  end

  private

  def process_stripe_payment
    # Stripe integration
    update!(status: :processing)

    begin
      # Stripe::PaymentIntent.create and confirm
      # This would be the actual Stripe integration
      update!(
        status: :completed,
        transaction_id: "stripe_#{SecureRandom.hex(8)}",
        paid_at: Time.current,
        metadata: { processor: "stripe" }
      )

      PaymentProcessingJob.perform_later(id)
    rescue => e
      update!(status: :failed, metadata: { error: e.message })
    end
  end

  def process_paypal_payment
    update!(status: :processing)

    begin
      # PayPal SDK integration would go here
      update!(
        status: :completed,
        transaction_id: "paypal_#{SecureRandom.hex(8)}",
        paid_at: Time.current,
        metadata: { processor: "paypal" }
      )

      PaymentProcessingJob.perform_later(id)
    rescue => e
      update!(status: :failed, metadata: { error: e.message })
    end
  end

  def process_mpesa_payment
    update!(status: :processing)

    begin
      # M-Pesa API integration would go here
      update!(
        status: :completed,
        transaction_id: "mpesa_#{SecureRandom.hex(8)}",
        paid_at: Time.current,
        metadata: { processor: "mpesa" }
      )

      PaymentProcessingJob.perform_later(id)
    rescue => e
      update!(status: :failed, metadata: { error: e.message })
    end
  end

  def process_bank_transfer
    update!(status: :processing)

    # Bank transfers typically require manual verification
    # Set to pending and notify admin
    update!(
      status: :pending,
      metadata: { processor: "bank_transfer", requires_verification: true }
    )
  end
end
