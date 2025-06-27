every 1.hour do
  runner "EmailApproval.where('expires_at < ?', Time.current).update_all(status: 'expired')"
end

every 1.day, at: "9:00 am" do
  rake "compliance:send_daily_summary"
end
