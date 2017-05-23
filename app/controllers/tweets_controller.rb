class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
  end
  
  def new
    @tweet = Tweet.new
  end
  
  def create
    @tweet = Tweet.new(tweets_param)
    if @tweet.save
      redirect_to tweets_path, notice: "つぶやき投稿しました！"
    else
      # p '----------'
      # p @tweet.errors.messages[:base].count
      # p @tweet.errors
      # p '----------'
      render 'new'
    end
  end
  
  
  private
    def tweets_param
      params.require(:tweet).permit(:content);
    end
end
