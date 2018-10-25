class GoalsController < ApplicationController

  def index
    @goals = current_user.goals
  end

  def new
    @goal = Goal.new
  end

  def edit
    @goal = Goal.new(params[:id])
  end

  def create
    p = params.require(:goal).permit(:category, :max).merge(user: current_user)
    @goal = Goal.new(p)
    if !@goal.save
      render :edit
    end
    redirect_to :index, notice: 'Meta criada'
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    if !@goal.update(params[:goal])
      render :edit
    end
  end

  def destroy
    render :show unless Goal.find(params[:id]).destroy
  end
end
