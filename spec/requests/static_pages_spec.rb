describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_selector('h1', text: I18n.t('home.banner.title')) }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_selector('h1', text: I18n.t('pages.about')) }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_selector('h1', text: I18n.t('pages.contacts.title')) }
  end

  describe "Contribute page" do
    before { visit contribute_path }
    it { should have_selector('h1', text: 'Help us build OpenSit!') }
  end
end
