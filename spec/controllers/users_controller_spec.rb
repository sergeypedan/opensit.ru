require 'spec_helper'

describe UsersController, type: :controller do
  let!(:buddha) { create(:user, username: 'buddha') }

  describe 'GET /me' do
    context 'signed in' do
      it 'should display the /me page' do
        sign_in buddha
        get :me
        expect(response).to be_successful
        expect(response).to render_template("users/me")
      end
    end

    context 'logged out' do
      it 'redirects to the front page' do
        get :me
        expect(response).to redirect_to('/users/sign_in')
      end
    end
  end

  describe 'GET /u/:username' do
    context 'no date range' do
      it 'displays user page' do
        get :show, params: { username: 'buddha' }
        expect(assigns(:user)).to eq(buddha)
        expect(response).to render_template("users/show")
      end
    end

    context 'username has period' do
      it 'displays user page' do
        buddha.update!(username: 'buddha.monk')
        get :show, params: { username: 'buddha.monk' }
        expect(assigns(:user)).to eq(buddha)
        expect(response).to render_template("users/show")
      end
    end

    context 'date specified' do
      context 'month' do
        it 'loads sits from that month' do
          create :sit, user: buddha, created_at: Time.zone.now
          create :sit, user: buddha, created_at: Time.zone.now - 35.days
          expect(buddha.sits.count).to eq 2

          get :show, params: { username: 'buddha', year: Date.today.year, month: Date.today.month }
          expect(assigns(:sits)).to have(1).items
          expect(assigns(:sits)).to eq(buddha.sits_by_month(year: Date.today.year, month: Date.today.month).communal.newest_first)
          expect(response).to render_template("users/show")
        end

        context 'invalid month' do
          it 'over 12' do
            get :show, params: { username: 'buddha', year: Date.today.year, month: '13' }
            expect(response).to redirect_to("/u/buddha")
            expect(flash[:error]).to eq('Invalid month!')
          end

          it 'non-numerical' do
            get :show, params: { username: 'buddha', year: Date.today.year, month: 'non-numerical' }
            expect(response).to redirect_to("/u/buddha")
            expect(flash[:error]).to eq('Invalid month!')
          end
        end
      end
    end

  end

  describe 'Profiles details and edit' do
    context 'someone elses' do
      it 'load profile' do
        @ananda = create :user, username: 'ananda', who: 'to get sat0ri'
        sign_in buddha
        get :show, params: { username: 'ananda' }
        expect(assigns(:user)).to eq(@ananda)
        expect(response.body).to include('to get sat0ri')
      end
    end
    context 'own profile' do
      it 'load profile with edit button' do
        @deva = create :user, username: 'deva', who: 'seduce lustful practitioners'
        sign_in @deva
        get :show, params: { username: 'deva' }
        expect(assigns(:user)).to eq(@deva)
        expect(response.body).to include('seduce lustful practitioners')
      end
    end
  end

  describe 'GET /u/:username/following' do
    it 'loads following page' do
      sign_in buddha
      get :following, params: { username: 'buddha' }
      expect(assigns(:user)).to eq(buddha)
      expect(response).to be_successful
      expect(response).to render_template("users/followers")
      expect(response.body).to have_selector('h1', text: I18n.t("following.followed_users"))
    end
  end

  describe 'GET /u/:username/followers' do
    it 'loads followers page' do
      sign_in buddha
      get :followers, params: { username: 'buddha' }
      expect(assigns(:user)).to eq(buddha)
      expect(response).to be_successful
      expect(response).to render_template("users/followers")
      expect(response.body).to have_selector(
                                 'h1',
                                 text: "#{I18n.t('following.following_users')}#{I18n.t('following.me')}"
                               )
    end
  end

  describe 'GET /u/:username/export' do
    it 'returns XML' do
      sign_in buddha
      get :export, params: { username: 'buddha', format: 'xml' }
      expect(response).to be_successful
      expect(response.content_type).to eq("application/xml")
    end

    it 'returns JSON' do
      sign_in buddha
      get :export, params: { username: 'buddha', format: 'json' }
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json")
    end
  end

  describe 'GET /feed' do
    before do
      @ananda = create :user, username: 'ananda'
      @sariputta = create :user, username: 'sariputta'

      create :sit, user: @ananda, body: 'un'
      create :sit, user: @sariputta, body: 'deux'
      create :sit, user: @sariputta, body: 'erpderp'
      create :sit, user: buddha, body: 'trois'
      create :sit, user: buddha, body: 'private!!!', private: true
    end

    context 'user feed' do
      it 'should generate an Atom feed' do
        get :feed, params: { username: 'buddha', format: 'atom' }

        expect(response).to be_successful
        expect(response).to render_template("users/feed")
        expect(response.content_type).to eq("application/atom+xml")
      end

      it 'shows only posts from that user' do
        get :feed, params: { username: 'sariputta', format: 'atom' }

        expect(response.body).to include('deux')
        expect(response.body).to include('erpderp')
        expect(response.body).to_not include('un')
      end

      it 'should not include private posts' do
        get :feed, params: { username: 'buddha', format: 'atom' }

        expect(response.body).to include('trois')
        expect(response.body).to_not include('private!!!')
      end
    end

    context 'global feed' do
      before do
        get :feed, params: { format: 'atom', scope: 'global' }
      end

      it 'should generate an Atom feed' do
        expect(response).to be_successful
        expect(response).to render_template("users/feed")
        expect(response.content_type).to eq("application/atom+xml")
      end

      it 'should include content from all users' do
        expect(response.body).to include('un')
        expect(response.body).to include('deux')
        expect(response.body).to include('trois')
      end

      it 'should not include private posts' do
        expect(response.body).to_not include('private!!!')
      end
    end
  end

end
