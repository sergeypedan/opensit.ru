require 'spec_helper'

describe 'Users' do
  let!(:buddha) { create :user, username: 'buddha' }

  subject { page }

  it 'should register a new user' do
    visit new_user_registration_path
    fill_in "user_username", with: "newbie"
    fill_in "user_email", with: "newbie@samsara.com"
    fill_in "user_password", with: "gunsbitchesbling"

    within(".new_user") do
      find_button(I18n.t('authorization.sign_up')).click
    end

    should have_content I18n.t('devise.registrations.signed_up')
    should have_content I18n.t('welcome_screen.title')
  end

  it 'blocks blacklisted emails' do
    visit new_user_registration_path
    fill_in "user_username", with: "newbie"
    fill_in "user_email", with: "dan@checkbesthosting.com"
    fill_in "user_password", with: "gunsbitchesbling"

    within(".new_user") do
      find_button(I18n.t('authorization.sign_up')).click
    end

    sleep(1)

    expect(page.body).to include(I18n.t(
      'sign_up.messages.registration_blocked',
      public_email: ENV.fetch("PUBLIC_EMAIL")
    ))
  end

  it 'does not block similar patterns' do
    visit new_user_registration_path
    fill_in "user_username", with: "newbie"
    fill_in "user_email", with: "dan@somethingpl.com" # include pl, but not .pl
    fill_in "user_password", with: "gunsbitchesbling"

    within(".new_user") do
      find_button(I18n.t('authorization.sign_up')).click
    end

    should have_content I18n.t('devise.registrations.signed_up')
    should have_content I18n.t('welcome_screen.title')
    expect(page.body).to_not include("Registration blocked")
  end

  describe 'registered users' do
    it 'should be able to log in' do
      visit user_session_path
      fill_in "user_email", with: "#{buddha.email}"
      fill_in "user_password", with: "#{buddha.password}"

      within(".new_user") do
        click_on I18n.t('authorization.sign_in')
      end

      should have_content I18n.t('devise.sessions.signed_in')
    end

  end

  describe 'username urls' do
    context 'existing users' do
      it 'with /u' do
        visit "/u/buddha"
        expect(status_code).to eq 200
      end

      it 'case insensitive' do
        visit '/u/BuDdHa'
        expect(status_code).to eq 200
      end
    end

    it 'should return 404 for non-existent users' do
      visit '/u/jesus'
      expect(status_code).to eq 404
    end
  end

end
