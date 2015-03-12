class HaikuEngine < ActiveRecord::Base

  def self.get_user_city (words)
    results = CLIENT.search('@dreamt_in', {lang: "en", count: 2}).attrs[:statuses]

    tweets = results.map do |tweet| 
      user = tweet[:user][:screen_name] 
      city = tweet[:text].split(' ')[1..-1].join(' ')
      Tweet.create(username: user, city: city)
      "#{user}|#{city}"
    end

  end

 def post_tweet (tweet)
   CLIENT.update(tweet)
 end

  def get_user_tweets (username)
    results = CLIENT.user_timeline(username, options = {count: 20})

    user_tweets = results.map do |tweet|
      tweet.text
    end
    
    cleaned_twitter_scrape = user_tweets.map do |tweet|
      tweet.split(' ').delete_if { |word| word.match(/\.[a-z]/) || word.include?('/') || word == 'RT'}.join(' ')
    end

  end

  def count_syllables (to_be_counted)
    Odyssey.flesch_kincaid_re(to_be_counted, true)["syllable_count"]
  end

  adj = {
    1 => %w(clean drab long plain quaint red blue green gray black white dead odd rich shy vast wrong right fierce brave calm kind nice broad deep flat high low steep wide big fat huge large short small tall faint loud brief fast slow late long old short swift young fresh hot loose sweet tart),
    2 => %w(cautious happy pleasant solid proper sunny hungry useful complete extreme alive distinct precise complete intense enough),
    3 => %w(adequate attractive average considered curious customary dangerous difficult exciting favourite liberal persistent substitute terrible typical)
    }

  adv = {
    1 => %w(fast),
    2 => %w(always later often shortly slowly sooner under perhaps indeed unless besides until above below before),
    3 => %w(blindingly certainly easily tragically),
    4 => %w(abnormally amazingly arrogantly beautifully brilliantly comfortably consistently delightfully dangerously efficiently  evidently financially fortunately genuinely  generally humorously  impatiently innocently judgmentally jubilantly knowledgeably  magically meaningfully naturally nevertheless obviously outrageously passionately personally questionably reasonably regularly separately  successfully tremendously ultimately unbearably vertically vigorously wholeheartedly wonderfully),
    5 => %w(figuratively)
    }

  def haiku_time (user, city)
    user_words = get_user_tweets(user) #is an array of strings
    tgr = EngTagger.new

    #return proper nouns from user
    proper_noun = user_words.map do |tweet|
      tgr.get_proper_nouns(tgr.add_tags(tweet))
    end
    pn = Hash[proper_noun.inject(:update).sort_by{|k, v| v}.reverse]

    #return basic verbs from user
    base_present_verbs = user_words.map do |tweet|
      tgr.get_base_present_verbs(tgr.add_tags(tweet))
    end
    bv = Hash[base_present_verbs.inject(:update).sort_by{|k, v| v}.reverse]

    #generate haiku line by line
    line_1 = "you enter your dream"

    line_2 = "to #{bv.first.first}"
    syllables_left_ln2 = 7-count_syllables(line_2)
    adv = adv[syllables_left_ln2].sample#retreive adverb to complete line_2
    line_2 = "#{line_2} #{adv}"#add above to end of line 2

    line_3 = "with #{pn.first.first}"
    syllables_left_ln3 = 5-count_syllables(line_3)
    adj = adj[5-syllables_left_ln3].sample#retreive adjective to complete line_3
    line_3 = "#{adj} #{line_3}"

    haiku = "#{line_1} / #{line_2} / #{line_3}".downcase
    post_tweet(haiku)
    
  end






#   twitter_scrape = ["I love living in the future. Tuesday's must-see: http://vimeo.com/75260457", "tiny house! tiny house! i want a tiny house! http://www.archdaily.com/512549/hb6b-karin-matz/ …", "if you happen to be in the mood for some mind-bending data visualisation http://wiki.polyfra.me/", "the new bond street http://www.archdaily.com/576495/new-photographs-released-of-london-s-new-subterranean-infrastructure-network/ … ", "a mesmerising start to your tuesday https://vimeo.com/108650530", "Oh. So this is what travel envy feels like. Enjoy: http://www.numinousnomads.com/", "OPTION 1 http://www.ted.com/talks/david_christian_big_history … | OPTION 2 https://www.youtube.com/watch?v=RKRksnjSxWI … | OPTION 3 ?", "Photo: Hverfjall, under the midnight sun. http://tmblr.co/ZItwYy1UrS58a", "I can barely even read French -- nursing an illustration crush on Gommette. http://tmblr.co/ZItwYy1Umv39E", "Upset about the loss of René Burri, inspirational human and the subject of my first (and enduring) photographer crush", "Sunday morning reading: Viktor Frankl on suffering as an essential part of the meaning of life. http://www.brainpickings.org/2013/03/26/viktor-frankl-mans-search-for-meaning/ …", "An anthropological look at in vitro meat, with some pretty striking illustrations. https://medium.com/re-form/the-in-vitro-meat-cookbook-321aad71ce9a … ", "I intuited an alien intelligence... the ability to perceive polarized light; a conflation of taste and touch.” http://www.newyorker.com/tech/elements/eating-octopus …", "The Music Go Traveling Map of Georgia. An ethnomusicological (crowd funded) journal. Her title might be better. http://www.thinglink.com/scene/567402368103088128 …", "Big Data is Better Data — machine learning vs. white collar in healthcare, and much more. http://www.ted.com/talks/kenneth_cukier_big_data_is_better_data …", "Biomedical informatics debate: those whose errors in judgment are among the most costly, refusing help.
#   http://www.nytimes.com/2012/12/04/health/quest-to-eliminate-diagnostic-lapses.html …", "RYOJI IKEDA : THE TRANSFINITE. Speaking of twitchy. https://www.youtube.com/watch?v=omDK2Cm2mwo …", "I’m getting a bit twitchy just looking at it. https://www.youtube.com/watch?v=HjHiC0mt4Ts …", "Lunchtime viewing: An enchanting animation of Allen Ginsberg's Howl https://www.youtube.com/watch?v=lM9BMVFpk80 …", "Life in anticipation, gathering stories and memories. Delightful. http://www.theatlantic.com/business/archive/2014/10/buy-experiences/381132 …", "Photo: Sam Caldwell, Broad o’th Straight (2014) http://tmblr.co/ZItwYy1SVHpyv ", "Photo: Sam Caldwell, Picket Line (2014) http://tmblr.co/ZItwYy1M0E2xW ", "Photoset: Artist Candas Sisman Reinvents Reality By Shifting The Way We Think About Digital Data “One of my... http://tmblr.co/ZItwYyx0n8T2 "]

# adj = {
#   1 => %w(clean, drab, long, plain, quaint, red, blue, green, gray, black, white, dead, odd, rich, shy, vast, wrong, right, fierce, brave, calm, kind, nice, broad, deep, flat, high, low, steep, wide, big, fat, huge, large, short, small, tall, faint, loud, brief, fast, slow, late, long, old, short, swift, young, fresh, hot, loose, sweet, tart),
#   2 => %w(cautious, happy, pleasant, solid, proper, sunny, hungry, useful, complete, extreme, alive, distinct, precise, complete, intense, enough),
#   3 => %w(Adequate, Attractive, Average, Considered, Curious, Customary, Dangerous , Difficult, Exciting, Favourite, Liberal, Persistent, Substitute, Terrible, Typical)
#   }

# adv = {
#   1 => %w(fast),
#   2 => %w(always, later, often, shortly, slowly, sooner, under, perhaps, indeed, unless, besides, until, above, below, before),
#   3 => %w(Blindingly, Certainly, Easily, tragically),
#   4 => %w(Abnormally, Amazingly, Arrogantly, Beautifully, Brilliantly, Comfortably, Consistently, Delightfully, Dangerously, Efficiently , Evidently, Financially, Fortunately, Genuinely , Generally, Humorously , Impatiently, Innocently, Judgmentally, Jubilantly, Knowledgeably , Magically, Meaningfully, Naturally, Nevertheless, Obviously, Outrageously, Passionately, Personally, Questionably, Reasonably, Regularly, Separately , Successfully, Tremendously, Ultimately, Unbearably, Vertically, Vigorously, Wholeheartedly, Wonderfully),
#   5 => %w(figuratively)
#   }

    # cleaned_twitter_scrape = twitter_scrape.map do |tweet|
    #   tweet.split(' ').delete_if { |word| word.match(/\.[a-z]/) || word.include?('/') }.join(' ')
    # end



  # syllables = {}

  # twitter_scrape.each_with_index do |word, index|

  #   syllables[word] = Odyssey.flesch_kincaid_re(word, true)["syllable_count"]

  # end


  # tgr = EngTagger.new

  # adj = cleaned_twitter_scrape.map do |tweet|
  #   tgr.get_adjectives(tgr.add_tags(tweet))
  # end

  # adj = adj.inject(:update)

  # noun = cleaned_twitter_scrape.map do |tweet|
  #   tgr.get_nouns(tgr.add_tags(tweet))
  # end

  # noun = noun.inject(:update)

  # noun = Hash[noun.inject(:update).sort_by{|k, v| v}.reverse]

  # proper_noun = cleaned_twitter_scrape.map do |tweet|
  #   tgr.get_proper_nouns(tgr.add_tags(tweet))
  # end

  # proper_noun = Hash[proper_noun.inject(:update).sort_by{|k, v| v}.reverse]

  # base_present_verbs = cleaned_twitter_scrape.map do |tweet|
  #   tgr.get_base_present_verbs(tgr.add_tags(tweet))
  # end

  # base_present_verbs = Hash[base_present_verbs.inject(:update).sort_by{|k, v| v}.reverse]

  # gerund_verbs = cleaned_twitter_scrape.map do |tweet|
  #   tgr.get_gerund_verbs(tgr.add_tags(tweet))
  # end

  # gerund_verbs = Hash[gerund_verbs.inject(:update).sort_by{|k, v| v}.reverse]

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
