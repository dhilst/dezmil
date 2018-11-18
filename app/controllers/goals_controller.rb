class GoalsController < ApplicationController

  def index
    @goals = current_user.goals
  end

  def new
    @goal = Goal.new
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def create
    p = params.require(:goal).permit(:category_id, :max).merge(user: current_user)
    @goal = Goal.new(p)
    if !@goal.save
      render :edit
      return
    end
    redirect_to action: :index, notice: 'Meta criada'
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    if !@goal.update(params.require(:goal).permit(:category_id, :max).merge(user: current_user))
      render :edit
      return
    end
    redirect_to action: :index, notice: 'Meta editada'
  end

  def destroy
    Goal.find(params[:id]).destroy
    redirect_to action: :index, notice: 'Meta removida'
  end
end
