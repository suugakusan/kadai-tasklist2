class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update]
  
  def index
    @task = current_user.tasks.build
    @pagy, @tasks = pagy(current_user.tasks.order(id: :desc), items:10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to root_url
    else
      @pagy, @tasks = pagy(current_user.task.order(id: :desc))
      flash[:danger] = 'Task が投稿されませんでした'
      redirect_to root_url
    end
  end

  def edit
     @task = current_user.tasks.find_by(id: params[:id])
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task = current_user.tasks.find_by(id: params[:id])
    @task.destroy
    flash[:success] = 'Task は正常に削除されました'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end

  def task_params
    params.require(:task).permit(:content, :status)
  end
end
