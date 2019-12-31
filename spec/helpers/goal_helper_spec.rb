require 'spec_helper'

describe GoalsHelper, type: :helper do
  describe '#rating_colour' do
    it 'under 50%' do
      expect(helper.rating_colour(49)).to eq 'red'
    end

    it 'under 70%' do
      expect(helper.rating_colour(64)).to eq 'amber'
    end

    it 'under 99%' do
      expect(helper.rating_colour(99)).to eq 'green'
    end

    it '100%' do
      expect(helper.rating_colour(100)).to eq 'gold'
    end
  end

end