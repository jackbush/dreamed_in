class HaikuEngine < ActiveRecord::Base

  @adj = {
    1 => %w(clean drab long plain quaint red blue green gray black white dead odd rich shy vast wrong right fierce brave calm kind nice broad deep flat high low steep wide big fat huge large short small tall faint loud brief fast slow late long old short swift young fresh hot loose sweet tart),
    2 => %w(cautious happy pleasant solid proper sunny hungry useful complete extreme alive distinct precise complete intense enough),
    3 => %w(adequate attractive average considered curious customary dangerous difficult exciting favourite liberal persistent substitute terrible typical)
    }

  @adv = {
    1 => %w(fast),
    2 => %w(always later often shortly slowly sooner under perhaps indeed unless besides until above below before),
    3 => %w(blindingly certainly easily tragically),
    4 => %w(abnormally amazingly arrogantly beautifully brilliantly comfortably consistently delightfully dangerously efficiently  evidently financially fortunately genuinely  generally humorously  impatiently innocently judgmentally jubilantly knowledgeably  magically meaningfully naturally nevertheless obviously outrageously passionately personally questionably reasonably regularly separately  successfully tremendously ultimately unbearably vertically vigorously wholeheartedly wonderfully),
    5 => %w(figuratively)
    }

  def self.get_user_tweets (username)
    results = CLIENT.user_timeline(username, options = {count: 15})
    user_tweets = results.map do |tweet|
      tweet.text
    end
    
    @length = results.length

    cleaned_twitter_scrape = user_tweets.map do |tweet|
      tweet.split(' ').delete_if { |word| word.match(/\.[a-z]/) || word.include?('/') || word == 'RT'}.join(' ')
    end
  end

  def self.count_syllables (to_be_counted)
    Odyssey.flesch_kincaid_re(to_be_counted, true)["syllable_count"]
  end

  def self.proper_nouns(user_words)
    proper_noun = user_words.map do |tweet|
      @tgr.get_proper_nouns(@tgr.add_tags(tweet))
    end
    @pn = Hash[proper_noun.inject(:update)].keys
  end

  def self.verbs(user_words)
    base_present_verbs = user_words.map do |tweet|
      @tgr.get_base_present_verbs(@tgr.add_tags(tweet))
    end
    
    verbs = Hash[base_present_verbs.inject(:update)].keys

    #removes any capitalizations of "am" and "are" which are returned by above method
    bv = verbs.delete_if {|x| x.casecmp("are").zero? || x.casecmp("am").zero? }
    @bv = verbs.delete_if {|x| x.start_with?("'") }
  end

  def self.haiku_time (user, city)

    user_words = self.get_user_tweets(user) #is an array of strings
    @tgr = EngTagger.new
 
    #return proper nouns from user's tweets
    self.proper_nouns(user_words)

    #return verb infinitives from user's tweets
    self.verbs(user_words)

    #generate haiku line by line

    if count_syllables(city) == 3
      line_1 = "dream in #{city}"
    else
      line_1 = "you enter your dream"
    end
    
    line_2 = "to #{@bv.sample}"
    syllables_left_ln2 = 7 - count_syllables(line_2)
    
    if syllables_left_ln2 > 0
      adv = @adv[syllables_left_ln2].sample
      line_2 = "#{line_2} #{adv}"
    end

    line_3 = "#{@pn.sample}"
    syllables_left_ln3 = 4 - self.count_syllables(line_3)

    if syllables_left_ln3 > 0
      adj = @adj[syllables_left_ln3].sample
      line_3 = "with #{adj} #{line_3}"
    else
      line_3 = "with #{line_3}"
    end
    
    if @length > 14
      haiku = "#{line_1} / #{line_2} / #{line_3}".downcase
    else 
      haiku = "serious error / you don't tweet enough to dream / in faraway lands"
    end

    haiku
  end

end
