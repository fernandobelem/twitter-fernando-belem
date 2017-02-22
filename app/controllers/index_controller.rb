class IndexController < ApplicationController
    before_action :load_options, :only => [:mostmention, :mostrelevant]

    @@tweets = Array.new

    #retrieves the eligible tweets hash and sort tweets acording to filter criteria
    #using most_mention resource
    def mostmention
        if @@tweets.size < 1
            set_tweets(get_eligible_tweets(get_tweets_from_api("/most_mentions")))   
        end
        sort_tweets_by_criteria(params[:options])
    end

    #retrieves the eligible tweets hash and sort tweets acording to filter criteria
    #using most_relevant resource
    def mostrelevant
        if @@tweets.size < 1
            set_tweets(get_eligible_tweets(get_tweets_from_api("/most_relevant")))   
        end
        sort_tweets_by_criteria(params[:options])
    end

    #whe user clicks in nav-bar this route will be triggered and will it will 
    ##instance as a new the @@tweets variable which is useful to 'reload' the tweets with new data 
    def home
        @@tweets = Array.new
    end

    #fill the tweet card data for the tweet.html.erb template
    def tweet
        @user_name = params['user']['name']
        @screen_name = params['user']['screen_name']
        @tweet_text = params['text']
        @created_at =  params['created_at'].in_time_zone(Time.zone)
        @followers = params['user']['followers_count']
        @retweets = params['retweet_count']
        @favourites = params['favorite_count']
    end
    
    #makes a get call for the locaweb twitter api 
    #retrieving an parsed json hash
    def get_tweets_from_api(uri)

         headers = {
            "Username" => "fernando.abelem@gmail.com"
         }

         response = JSON.parse(HTTParty.get(
            'http://tweeps.locaweb.com.br/tweeps' + uri,
            :headers => headers
            ))

        return response
    end

    #method used to search and return eligible tweets 
    #according to tweets that mentions locaweb 
    #and tweets that are replies from a locaweb tweet 
    def get_eligible_tweets(response)
        eligible_tweets = Array.new
        response["statuses"].each do |s|

            if s['in_reply_to_user_id'] == 42
                s['entities']['user_mentions'].each do |um| 
                    if um['id'] ==  42
                       eligible_tweets.push(s)
                    end
                end
            end
        end
        return eligible_tweets
    end

    #sort tweets array according with the specified criteria 
    def sort_tweets_by_criteria(criteria)
       @sorted_tweets = Array.new
       if criteria == '3'
          @sorted_tweets = @@tweets.sort_by{|e| e['retweet_count']}.reverse!
          puts 'ordenado por retweet'
       elsif criteria == '2'
          @sorted_tweets = @@tweets.sort_by{|e| e['favorite_count']}.reverse!
          puts 'ordenado por favoritos'
       else
          @sorted_tweets = @@tweets.sort_by{|e| e['user']['followers_count'] }.reverse!
          puts 'ordenado por followers'

       end   

       return @sorted_tweets
    end

    def showjson
       @jsonTweets = sort_tweets_by_criteria(params[:options])
    end

    def set_tweets(param_tweets)
        @@tweets = param_tweets
    end

    def load_options
        @options = { "Most Followers" => 1, "Most Favourites" => 2, "Most Retweets" => 3 }
    end


end
