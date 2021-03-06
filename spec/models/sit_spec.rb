describe Sit, type: :model do
  let(:buddha) { create(:buddha) }
  let(:ananda) { create(:ananda) }

  describe 'scopes' do
    context 'without_diaries' do
      it 'does not return diaries' do
        create(:sit, user: buddha, created_at: Date.today)
        create(:sit, user: buddha, created_at: Date.today, s_type: "diary", title: Faker::Lorem.word)
        expect(buddha.sits.without_diaries.count).to eq(1)
      end
    end
  end

  describe 'creating a user' do
	  it 'sets the streak to 0' do
	    user = create(:user)
	    expect(user.streak).to eq(0)
	  end
	end

	describe "streaks" do
  	context "sat yesterday" do
	  	it "increments streak by 2" do
	  		expect(buddha.streak).to eq 0
	  		create(:sit, user: buddha, created_at: Time.current - 1.day)
	  		create(:sit, user: buddha, created_at: Time.current)
	  		expect(buddha.reload.streak).to eq 2
	  	end

	  	it "doesn't increment if already sat today" do
        1.upto(2) do |i|
          create(:sit, user: buddha, created_at: Time.current - i.days)
        end
        # Morning sit
        create(:sit, user: buddha)
        expect(buddha.reload.streak).to eq 3
        # Evening sit
	  	  create(:sit, user: buddha, created_at: Time.current + 1.second)
	  		expect(buddha.reload.streak).to eq 3
	  	end
	  end

	  context "missed a day" do
	  	it "resets streak" do
	  		2.times do |i|
          create(:sit, user: buddha, created_at: Date.yesterday - (i + 1))
        end
	  		create(:sit, user: buddha, created_at: Date.current)
	  		expect(buddha.reload.streak).to eq 0
	  	end
	  end
	end

  context "stubs" do
  	it "should allow sits without bodies" do
  		sit = create(:sit, user: buddha, body: '')
  		expect(sit.valid?).to eq(true)
  	end
  end
end

# == Schema Information
#
# Table name: sits
#
#  id               :integer          not null, primary key
#  body             :text
#  disable_comments :boolean          default(FALSE), not null
#  duration         :integer
#  s_type           :string           default("meditation"), not null
#  title            :string
#  views            :integer          default(0)
#  visibility       :enum             default("public")
#  user_id          :integer
#
