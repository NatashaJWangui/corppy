require "rails_helper"

RSpec.describe ComplianceMailer, type: :mailer do
  describe "review_assigned" do
    let(:mail) { ComplianceMailer.review_assigned }

    it "renders the headers" do
      expect(mail.subject).to eq("Review assigned")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "document_approved" do
    let(:mail) { ComplianceMailer.document_approved }

    it "renders the headers" do
      expect(mail.subject).to eq("Document approved")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "document_rejected" do
    let(:mail) { ComplianceMailer.document_rejected }

    it "renders the headers" do
      expect(mail.subject).to eq("Document rejected")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
