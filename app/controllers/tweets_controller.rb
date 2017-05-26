class TweetsController < ApplicationController
  
  before_action :set_tweet, only:[:edit, :update, :destroy]
  
  def index
    @tweets = Tweet.order('updated_at DESC')
  end
  
  def new
    if params[:back]
      @tweet = Tweet.new(tweets_param)
    else
      @tweet = Tweet.new
    end
  end
  
  def re_new
    @tweet = Tweet.new(tweets_param)
    render 'new'
  end
  
  def create
    @tweet = Tweet.new(tweets_param)
    if @tweet.save
      redirect_to tweets_path, notice: "つぶやきを投稿しました！"
    else
      # p '----------'
      # p @tweet.errors.messages[:base].count
      # p @tweet.errors
      # p '----------'
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @tweet.update(tweets_param)
      redirect_to tweets_path, notice: "つぶやきを更新しました！"
    else
      render 'edit'
    end
  end
  
  def destroy
    @tweet.destroy
    redirect_to tweets_path, notice: "つぶやきを削除しました！"
  end
  
  def confirm
    @tweet = Tweet.new(tweets_param)
    render :new if @tweet.invalid?
  end
  
  
  private
    def tweets_param
      params.require(:tweet).permit(:content);
    end
    
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end
end
