class Tweet < ActiveRecord::Base

  def self.post_tweet (tweet)
    CLIENT.update(tweet)
  end

end
