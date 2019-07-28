require 'rails_helper'
require 'pry'

# Specs in this file have access to a helper object that includes
# the TransactionHelper. For example:
#
# describe TransactionHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TransactionsHelper, type: :helper do
  let!(:u) { create :user }
  let!(:uncat) { create :category, :uncategorized }
  let!(:global_cat) { create :category, display_name: 'Global Category' }
  let!(:user_cat) { create :category, user_id: u.id , display_name: 'User Category' }
  let!(:another_user_cat) { create :category, display_name: 'Another User Category', user_id: create(:user).id }
  let!(:statement) { create :statement, user: u }
  let!(:transaction) { create :transaction, statement: statement }

  before do
    sign_in u
  end

  it do
    output = helper.categories(transaction)
    expect(uncat.display_name).to eql('Uncategorized')
    expect(global_cat.display_name).to eql('Global Category')
    expect(user_cat.display_name).to eql('User Category')
    expect(another_user_cat.display_name).to eql('Another User Category')
    expect(Category.count).to eql(4)

    expect(output).not_to match('<option .*?>Uncategorized</option>')
    expect(output).not_to match('<option .*?>Another User Category</option>')
    expect(output).to match('<option .*?>Global Category</option>')
    expect(output).to match('<option .*?>User Category</option>')
  end
end
