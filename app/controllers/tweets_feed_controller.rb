require_relative '../services/twitter_feed_service'
require_relative '../services/google_map_service'
require 'json'

class TweetsFeedController < ApplicationController
  def index
    @tweets_feed  = []
    @tweets_by_location = {}
    @tweets_to_show = []
    puts params.inspect
    if params.has_key?("search_string")
      @display_option = params["display_option"]
      @search_string = params["search_string"]
      begin
        @tweets_feed = TwitterFeedService.fetch(@search_string,params["number_of_tweets"])  
        #@tweets_feed = get_tweets
        if @display_option.eql? "show_by_location"
          sort_tweets
          write_tweets_to_file
          puts @tweets_by_location
        end
      rescue TweetStream::ReconnectError => re
        @error_message = re.message
      rescue Exception => e
        @error_message = e.message
      end
    end
  end

  def show
    if params.has_key?("search_string") and params.has_key?("display_option")
      index
    else
      puts "id - #{params['id']}"
      @tweets_by_location = JSON.parse(IO.read("tweets.json"))
      @tweets_to_show = @tweets_by_location[params["id"]]
      @search_string = params["search_string"]
      @display_option = "show_by_location"
    end
    render "index"
  end

  private

  def sort_tweets
    @tweets_feed.each do |tweet|
      tweet_location = (tweet["location"].empty?) ?  "others" : GoogleMapService.get_location(tweet["location"])
      @tweets_by_location[tweet_location] = [] unless @tweets_by_location.has_key? tweet_location
      @tweets_by_location[tweet_location] << tweet 
    end  
  end

  def write_tweets_to_file
    fJson = File.open("tweets.json","w")
    fJson.write(@tweets_by_location.to_json)
    fJson.close
  end
  
  def get_tweets
    [{"text"=>"67th reminder to do something for the country! JAI HIND!", "created_at"=>"2013-08-15 21:11:39 +0530", "location"=>"Bangalore", "geo"=>nil}, {"text"=>"@gagan_riar Jai Hind http://t.co/Vp93JclGgJ", "created_at"=>"2013-08-15 21:11:42 +0530", "location"=>"Amritsar", "geo"=>nil}]
      #{"text"=>"@imVkohli . Jai hind", "created_at"=>"2013-08-15 21:11:57 +0530", "location"=>"", "geo"=>nil}, {"text"=>"Proud to be an Indian. Jai Hind!!", "created_at"=>"2013-08-15 21:12:04 +0530", "location"=>"Guwahati, India", "geo"=>nil}, {"text"=>"@msdhoni u r d gr8 cptn i 've evr knwn in my entire lif nd u'l remain d same to me\nthank u for insprng me in life,'ll lov u alwys\njai hind!", "created_at"=>"2013-08-15 21:12:12 +0530", "location"=>"India", "geo"=>nil}, {"text"=>"#BBV happy independence day to all my countrymen..jai hind jai hind ki sena", "created_at"=>"2013-08-15 21:12:26 +0530", "location"=>"Hkd", "geo"=>nil}, {"text"=>"RT @imVkohli: Happy independence day to everyone. Lets liberate our thoughts and vision from today. Jai hind . This day has a different vib", "created_at"=>"2013-08-15 21:12:27 +0530", "location"=>"", "geo"=>nil},{"text"=>"Happy Independence day..Jai Hind", "created_at"=>"2013-08-15 21:12:34 +0530", "location"=>"", "geo"=>nil}, {"text"=>"RT @SrBachchan: T 1124 -JAI HIND !! JAI HIND !! JAI HIND !!", "created_at"=>"2013-08-15 21:12:39 +0530", "location"=>"new delhi", "geo"=>nil}, {"text"=>"Happy independence day friends...i want to be the last person to wish....jai hind!!", "created_at"=>"2013-08-15 21:12:40 +0530", "location"=>"Tirunelveli,india", "geo"=>nil}, {"text"=>"RT @pragyanojha: Happy INDEPENDENCE Day my friends!!! Jai Hind http://t.co/6A8NVR3o79", "created_at"=>"2013-08-15 21:12:47 +0530", "location"=>"", "geo"=>nil}, {"text"=>"RT @imVkohli: Happy independence day to everyone. Lets liberate our thoughts and vision from today. Jai hind . This day has a different vib", "created_at"=>"2013-08-15 21:12:56 +0530", "location"=>"India", "geo"=>nil}, {"text"=>"RT @pragyanojha: Happy INDEPENDENCE Day my friends!!! Jai Hind http://t.co/6A8NVR3o79", "created_at"=>"2013-08-15 21:13:08 +0530", "location"=>"U.S.A", "geo"=>nil}, {"text"=>"Vande Matram... Jai Hind !!!\n\n#HappyIndependenceDay   #ThisIsMyFreedom http://t.co/c0jq8dMYKB", "created_at"=>"2013-08-15 21:13:14 +0530", "location"=>"India", "geo"=>nil}, {"text"=>"HAPPY INDEPENDENCE DAY !!! JAI HIND...JAI BHARAT", "created_at"=>"2013-08-15 21:13:15 +0530", "location"=>"Jhunjhunu, Rajasthan", "geo"=>nil}, {"text"=>"RT @imVkohli: Happy independence day to everyone. Lets liberate our thoughts and vision from today. Jai hind . This day has a different vib", "created_at"=>"2013-08-15 21:13:18 +0530", "location"=>"", "geo"=>nil}, {"text"=>"RT @Prakash_Sharma: Both \"Vande Matram\" and \"Bharat Mata ki jai\" were missing from Red Fort today. They have been declared communal. Next w", "created_at"=>"2013-08-15 21:13:30 +0530", "location"=>"Hindustan", "geo"=>nil}, {"text"=>"RT @presrajapakse Jai Hind, except for that 13A business.", "created_at"=>"2013-08-15 21:13:49 +0530", "location"=>"Sri Lanka", "geo"=>nil}, {"text"=>"@imVkohli to u too chikoo :D\njai hind!", "created_at"=>"2013-08-15 21:14:00 +0530", "location"=>"India", "geo"=>nil}, {"text"=>"Watching the Diya aur bati special episode of @iamsrk now on star plus. This one seems good. Also, happy Independence Day. Jai hind!", "created_at"=>"2013-08-15 21:14:03 +0530", "location"=>"Calcutta, India", "geo"=>nil}, {"text"=>"RT @ShailendraS7: Jai hind...vande mataram..mera bharat mahaan...i love india...a billion poeple but a very few phrases to express the patr", "created_at"=>"2013-08-15 21:14:19 +0530", "location"=>"Mumbai, India", "geo"=>nil}, {"text"=>"@janlokpal @PMOIndia where is D barometer of people?We need Jobs,Growth,Salary hike same as pre-Janlokpal movement? Jai Hind Red Fort", "created_at"=>"2013-08-15 21:14:29 +0530", "location"=>"Chandigarh", "geo"=>nil}, {"text"=>"RT @tajinderbagga: India Needs Modi not because he deserves to be the PM But because India Deserves A PM like Him. Jai Hind  #HappyIndepend", "created_at"=>"2013-08-15 21:14:35 +0530", "location"=>"Mumbai, India", "geo"=>nil}]
  end

end
