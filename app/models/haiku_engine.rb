class HaikuEngine < ActiveRecord::Base

  def self.old_search_words words
      a = CLIENT.search('@justinbieber', {lang: "en", count: 5})
      tweets = []
      a.each do |tweet|
        tweets << tweet.text
      end
      binding.pry
      nil
  end 

  def self.get_user_city (words)
    results = CLIENT.search('@dreamt_in', {lang: "en", count: 5})
    tweets = results.map { |tweet| tweet.text }
    # break down to populate username and city in db
  end

  def get_user_tweets (username)
    results = CLIENT.user_timeline(username, options = {count: 2})
  end

  twitter_scrape = ["I love living in the future. Tuesday's must-see: http://vimeo.com/75260457", "tiny house! tiny house! i want a tiny house! http://www.archdaily.com/512549/hb6b-karin-matz/ …", "if you happen to be in the mood for some mind-bending data visualisation http://wiki.polyfra.me/", "the new bond street http://www.archdaily.com/576495/new-photographs-released-of-london-s-new-subterranean-infrastructure-network/ … ", "a mesmerising start to your tuesday https://vimeo.com/108650530", "Oh. So this is what travel envy feels like. Enjoy: http://www.numinousnomads.com/", "OPTION 1 http://www.ted.com/talks/david_christian_big_history … | OPTION 2 https://www.youtube.com/watch?v=RKRksnjSxWI … | OPTION 3 ?", "Photo: Hverfjall, under the midnight sun. http://tmblr.co/ZItwYy1UrS58a", "I can barely even read French -- nursing an illustration crush on Gommette. http://tmblr.co/ZItwYy1Umv39E", "Upset about the loss of René Burri, inspirational human and the subject of my first (and enduring) photographer crush", "Sunday morning reading: Viktor Frankl on suffering as an essential part of the meaning of life. http://www.brainpickings.org/2013/03/26/viktor-frankl-mans-search-for-meaning/ …", "An anthropological look at in vitro meat, with some pretty striking illustrations. https://medium.com/re-form/the-in-vitro-meat-cookbook-321aad71ce9a … ", "I intuited an alien intelligence... the ability to perceive polarized light; a conflation of taste and touch.” http://www.newyorker.com/tech/elements/eating-octopus …", "The Music Go Traveling Map of Georgia. An ethnomusicological (crowd funded) journal. Her title might be better. http://www.thinglink.com/scene/567402368103088128 …", "Big Data is Better Data — machine learning vs. white collar in healthcare, and much more. http://www.ted.com/talks/kenneth_cukier_big_data_is_better_data …", "Biomedical informatics debate: those whose errors in judgment are among the most costly, refusing help.
  http://www.nytimes.com/2012/12/04/health/quest-to-eliminate-diagnostic-lapses.html …", "RYOJI IKEDA : THE TRANSFINITE. Speaking of twitchy. https://www.youtube.com/watch?v=omDK2Cm2mwo …", "I’m getting a bit twitchy just looking at it. https://www.youtube.com/watch?v=HjHiC0mt4Ts …", "Lunchtime viewing: An enchanting animation of Allen Ginsberg's Howl https://www.youtube.com/watch?v=lM9BMVFpk80 …", "Life in anticipation, gathering stories and memories. Delightful. http://www.theatlantic.com/business/archive/2014/10/buy-experiences/381132 …", "Photo: Sam Caldwell, Broad o’th Straight (2014) http://tmblr.co/ZItwYy1SVHpyv ", "Photo: Sam Caldwell, Picket Line (2014) http://tmblr.co/ZItwYy1M0E2xW ", "Photoset: Artist Candas Sisman Reinvents Reality By Shifting The Way We Think About Digital Data “One of my... http://tmblr.co/ZItwYyx0n8T2 "]

    cleaned_twitter_scrape = twitter_scrape.map do |tweet|
      tweet.split(' ').delete_if { |word| word.match(/\.[a-z]/) || word.include?('/') }.join(' ')
    end



  # syllables = {}

  # twitter_scrape.each_with_index do |word, index|

  #   syllables[word] = Odyssey.flesch_kincaid_re(word, true)["syllable_count"]

  # end


  tgr = EngTagger.new

  adj = cleaned_twitter_scrape.map do |tweet|
    tgr.get_adjectives(tgr.add_tags(tweet))
  end

  adj = adj.inject(:update)

  noun = cleaned_twitter_scrape.map do |tweet|
    tgr.get_nouns(tgr.add_tags(tweet))
  end

  # noun = noun.inject(:update)

  noun = Hash[noun.inject(:update).sort_by{|k, v| v}.reverse]

  proper_noun = cleaned_twitter_scrape.map do |tweet|
    tgr.get_proper_nouns(tgr.add_tags(tweet))
  end

  proper_noun = Hash[proper_noun.inject(:update).sort_by{|k, v| v}.reverse]

  base_present_verbs = cleaned_twitter_scrape.map do |tweet|
    tgr.get_base_present_verbs(tgr.add_tags(tweet))
  end

  base_present_verbs = Hash[base_present_verbs.inject(:update).sort_by{|k, v| v}.reverse]

  gerund_verbs = cleaned_twitter_scrape.map do |tweet|
    tgr.get_gerund_verbs(tgr.add_tags(tweet))
  end

  gerund_verbs = Hash[gerund_verbs.inject(:update).sort_by{|k, v| v}.reverse]

  # infinitive_verbs = cleaned_twitter_scrape.map do |tweet|
  #   tgr.get_infinitive_verbs(tgr.add_tags(tweet))
  # end

  # infinitive_verbs = Hash[infinitive_verbs.inject(:update).sort_by{|k, v| v}.reverse]







  # puts "Proper nouns: #{proper_noun}"
  # puts "Base present Verbs: #{base_present_verbs}"
  # puts "Gerund verbs: #{gerund_verbs}"







  # Get a readable version of the tagged text
  # Add part-of-speech tags to text

  # readable = EngTagger.new.get_readable(string)

  # puts readable

  # {word: [syllable_no, part_of_speech]}

  # adj = {1: [word, word, wod]}

end
