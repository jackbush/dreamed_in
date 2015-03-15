namespace :twitter do
  desc "maintains our twitter feed"

  task get_tweets: :environment do
    puts 'FETCHING TWEETS...'
    begin
      results = CLIENT.search('@dreamt_in', {count: 11}).attrs[:statuses]
      tweets = results.map { |tweet| tweet[:text] }

      tweets = results.each do |tweet|
        user = tweet[:user][:screen_name] 
        city = tweet[:text].split(' ')[1..-1].join(' ')
        Tweet.find_or_create_by(username: user, city: city)
        puts "#{user} | #{city}"
      end

      puts "#{tweets.count} TWEETS RECEIVED"
      
      if tweets.count > 0
        Rake::Task["twitter:respond_to_tweets"].execute
      end
    rescue => e
      puts "ERROR: #{e}"
    end
  end

  task respond_to_tweets: :environment do
    puts 'CRAFTING RESPONSES...'
    begin
      respond = Tweet.where(tweet: nil)
      respond.each do |tweet|
        name = tweet.username
        city = tweet.city
        response = "@#{name} #{HaikuEngine.haiku_time(name, city)}"
        Tweet.post_tweet(response)
        tweet.update_attributes(tweet: response)
        puts response
      end
      
      puts 'SENT'
    rescue => e
      puts "ERROR: #{e}"
    end
  end

end
