class ProfileFacade

  def initialize(user)
    @user = user
  end

  def genres_human_hash
    User::GENDERS.map { |genre| [genre, I18n.t("gender.#{genre}")] }
  end

end
