class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def index
    weather_url = 'http://api.openweathermap.org/data/2.5/weather?q=singapore&appid=49c8b93b67e42d078d572c8368f538a8'
    weather_response = HTTParty.get(weather_url)

    news_url = 'https://newsapi.org/v1/articles?source=buzzfeed&sortBy=latest&apiKey=6a1b87ded86d47cf8f7b18a230f094bf'
    response = HTTParty.get(news_url)

    @news_data = response
    @weather_data = weather_response
    # render json: @weather_data

    @all_posts = current_user.posts
    @new_post = current_user.posts.new

    # render json: @all_posts

    # @new_post = Post.new #post isnt tagged to any user
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    render html: 'show form to create new post'
  end

  def edit
    @current_post = Post.find(params[:id])
  end

  def create
    # allowing mass assignment
    # creating_post = post_params

    # creating_post = current_user.post.build
    # creating_post.title = params[:post][:title]

    Post.create(post_params)
    redirect_to posts_path
  end

  def update
    # render json: post_update_params
    updated_post = Post.find(params[:id])

    # updated_post.title = params[:post][:title]
    # updated_post.content = params[:post][:content]
    # updated_post.user_id = params[:post][:user_id]
    # updated_post.foo = params[:post][:foo]
    # updated_post.past = params[:post][:past]

    updated_post.update(post_update_params)

    redirect_to posts_path
    # render html: 'updated'
  end

  def destroy
    # Post.destroy(params[:id])

    deleted_post = Post.find(params[:id])
    deleted_post.destroy

    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title,:content, :user_id)
  end

  def post_update_params
    params.require(:post).permit(:title,:content)
  end
end
