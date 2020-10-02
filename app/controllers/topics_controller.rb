class TopicsController < ApplicationController
  before_action :load_topic, except: %i(index new create)
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @topics = Topic.all
  end

  def new
    @topic = Topic.new
  end

  def show; end

  def create
    @topic = Topic.new topic_params

    if @topic.save
      flash[:success] = t "topic.create"
      redirect_to posts_path
    else
      flash.now[:warning] = t "topic.createfail"
      render :new
    end
  end

  def destroy
    if @topic.destroy
      flash[:success] = t "topic.delete"
    else
      flash[:warning] = t "topic.deletefail"
    end
    redirect_to posts_path
  end

  private

  def topic_params
    params.require(:topic).permit(:name)
  end

  def load_topic
    @topic = Topic.find_by id: params[:id]
    return if @topic

    flash[:warning] = t "topic.notfound"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "topic.login_remind"
    redirect_to login_path
  end

  def correct_user
    @topic = current_user.topics.find_by id: params[:id]
    return if @post

    flash[:warning] = t "topic.notfound"
    redirect_to root_path
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
