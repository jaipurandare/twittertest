require 'tweetstream'
class TwitterFeedService
  MAX_TIME = 30
  def self.fetch(search_string,num=10)
    tweets_feed = []
    EM.run do 
      tweet_stream = TweetStream::Client.new
      tweet_stream.on_error do |message|
        raise Exception.new("Error: Twitter streamed errored out - #{message}")
      end.on_reconnect do |timeout,retries|
        raise TweetStream::ReconnectError.new("Reconnect: Twitter streamed errored out - #{timeout}, #{retries}") unless retries.zero?
      end.track(search_string) do |status, client|
        puts status.text
        tweets_feed.push({"text" => status.text, "created_at" => status.created_at, "location" => status.user["location"], "geo" => status.geo})
        client.stop if tweets_feed.size >= num.to_i
      end
      EM::PeriodicTimer.new(MAX_TIME) do
        if tweets_feed.empty?
          tweet_stream.stop
          raise Exception.new("Didnt receive any results from twitter for search string #{search_string} for time #{MAX_TIME} seconds")
        end
      end
    end
    tweets_feed
  end
  
end
