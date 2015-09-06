json.array!(@inden_cards) do |inden_card|
  json.extract! inden_card, :ru_staff, :serial_no, :daily_limit, :monthly_limit, :issue_date, :start_date, :end_date, :staff_id, :unit_id
  json.url inden_card_url(inden_card, format: :json)
end
