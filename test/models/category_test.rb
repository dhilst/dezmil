require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  test 'uncategorized' do
    user = User.create(email: 'foo@bar', password: 'foo', confirmed_at: DateTime.now)
    Category.create(name: 'uncategorized', display_name: 'No category')
    Category.create(name: 'some_global_cat', display_name: 'Global Cat')
    Category.create(name: 'user_cat', display_name: 'User Cat')

    assert user.categories.where.not(name: 'uncategorized').count == 2
  end
end
