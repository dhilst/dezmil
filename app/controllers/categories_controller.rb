class CategoriesController < ApplicationController
	before_action :authenticate_user!
  before_action :load_category, only: %i[update edit destroy]

  def index
    @categories = current_user.categories
  end

  def new
    @category = Category.new
  end

  def create
    Category.create(cat_params)
    flash[:success] = "Categoria criada com sucesso"
    redirect_to action: :index
  end

  def edit
  end

  def update
    return head 401 if @category.user_id != current_user.id
    @category.update(cat_params)
    flash[:success] = "#{@category.display_name} atualizada"
    redirect_to action: :index
  end

  def destroy
    uncat = Category.find_by(name: 'uncategorized')
    Transaction.where(category: @category).update(category: uncat)
    @category.delete
    flash[:success] = "#{@category.display_name} deletada"
    redirect_to action: :index
  end

  private

  def cat_params
    params.require(:category).permit(:display_name, :color, :help).merge(user_id: current_user.id)
  end

  def load_category
    @category ||= Category.find(params[:id])
  end
end
