require 'rails_helper'

RSpec.describe Category do
  describe "should exclude sentinel category only" do
    let!(:current_user) { create :user }
    let!(:another_user) { create :user }
    let!(:ucat) { create :category, user_id: current_user.id }
    let!(:acat) { create :category, user_id: another_user.id }

    it do
      expect(current_user.categories.last).to eql(ucat)
    end
  end
end
