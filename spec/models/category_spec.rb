require 'rails_helper'

RSpec.describe Category do
  describe "should exclude sentinel category only" do
    let(:u) { create :user }

    it 'should be pesisted' do
      expect(u.persisted?).to be(true), u.errors.messages
    end

    before do
      create :category, :uncategorized
      create :category
      create :category, user_id: u.id, name: 'some_user_category'
    end

    it 'should exclude uncategoized' do
      cats = u.categories
      expect(cats.count).to be(2)
      expect(cats.pluck :name).not_to include('uncategorized')
      expect(cats.pluck :name).to include('some_user_category')
    end

    it 'should return only custom categories' do
      cats = u.custom_categories
      expect(cats.pluck :name).to eql(['some_user_category'])
    end
  end
end
