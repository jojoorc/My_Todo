class TodosController < ApplicationController
  before_action :load_todo, only: [:edit, :update, :destroy]
  before_action :authenticate!

  def index
    @todos = @current_user.todos
    @todo = Todo.new
    load_todos
    build_todo
  end

  def edit
  end

  def update
    build_todo
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to todos_path, notice: "更新成功" }
      else
        format.html { render :edit }
      end
    end
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.user_id = @current_user.id
    respond_to do |format|
      if @todo.save!
        format.html { redirect_to todos_path, notice: "创建成功" }
      else
        format.html { render :index }
      end
    end
  end

  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to todos_path, notice: '删除成功' }
    end
  end

  private

  def authenticate!
    @current_user = User.find_by(id: session[:user_id])
    if current_user.blank?
      redirect_to login_path and return
    end
  end

  def load_todo
    @todo ||= todo_scope.find(params[:id])
  end

  def load_todos
    @todos ||= todo_scope.all
  end

  def build_todo
    @todo ||= todo_scope.new
    @todo.attributes = todo_params
  end

  def todo_scope
    Todo.ordered
  end

  def todo_params
    todo_params = params[:todo]
    todo_params ? todo_params.permit(:title, :remark, :is_finished) : {}
  end
end
