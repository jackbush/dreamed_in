class Tweet < ActiveRecord::Base

  def post_tweet (tweet)
    CLIENT.update(tweet)
  end

end
