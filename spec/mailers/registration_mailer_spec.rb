require "rails_helper"

RSpec.describe RegistrationMailer, type: :mailer do
  describe "document_preview" do
    let(:mail) { RegistrationMailer.document_preview }

    it "renders the headers" do
      expect(mail.subject).to eq("Document preview")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "approval_request" do
    let(:mail) { RegistrationMailer.approval_request }

    it "renders the headers" do
      expect(mail.subject).to eq("Approval request")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "payment_confirmation" do
    let(:mail) { RegistrationMailer.payment_confirmation }

    it "renders the headers" do
      expect(mail.subject).to eq("Payment confirmation")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "document_ready" do
    let(:mail) { RegistrationMailer.document_ready }

    it "renders the headers" do
      expect(mail.subject).to eq("Document ready")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "welcome_email" do
    let(:mail) { RegistrationMailer.welcome_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
