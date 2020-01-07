require 'spec_helper'

RSpec.describe ReportsController, :type => :controller do

  before :each do
    @buddha = create :user
    @ananda = create :user, username: 'ananda'
    @sit = create :sit, user: @buddha
    @report = build :report, user: @ananda, reportable_id: @sit.id, reportable_type: @sit.class.to_s
    sign_in @ananda, scope: :user
  end

  describe "POST create" do
    let(:params) do
      { report: @report.as_json(only: [:reportable_id, :reportable_type, :user_id, :reason, :body]) }
    end

    it "creates a report" do
      expect(Report.count).to eq 0
      post :create, params: params
      expect(response).to have_http_status(:redirect)
      expect(Report.count).to eq 1
      expect(@buddha.reports.count).to eq 0
      expect(@ananda.reports.count).to eq 1
      expect(@sit.reports.count).to eq 1
    end
  end

end
