require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "should exclude sentinel category only" do
    let(:u) { User.create(email: 'foo@bar') }

    before do
      Category.create(name: 'uncategorized')
      Category.create(name: 'another_category')
      Category.create(name: 'some_user_category', user_id: u.id)
    end

    it 'should exclude uncategoized' do
      expect(u.categories.count).to be(2)
      expect(u.categories.pluck(:name)).not_to include('uncategorized')
    end
  end
end
