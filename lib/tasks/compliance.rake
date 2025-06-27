namespace :compliance do
  desc "Send daily summary to compliance officers"
  task send_daily_summary: :environment do
    User.compliance_officer.find_each do |officer|
      pending_reviews = ComplianceReview.pending.where(reviewer: officer).count

      if pending_reviews > 0
        ComplianceMailer.daily_summary(officer.id, pending_reviews).deliver_now
      end
    end
  end
end
