require 'rails_helper'

describe IndexController, type: :controller do

	context "Validar recursos do servico" do 
		it 'Chamada para uri /mostrelevant nao deve retonar nil' do
			expect(controller.get_tweets_from_api('mostrelevant')).not_to be_nil
		end
		it 'Chamada para uri /mostmention nao deve retornar nil' do
			expect(controller.get_tweets_from_api('mostmention')).not_to be_nil
		end
	end

	context "Validar Tweets elegiveis" do 
		it 'Tweets que mencionem o usuario locaweb devem estar na lista' do

			tweets = controller.get_eligible_tweets(controller.get_tweets_from_api('/mostrelevant'))

			tweets.each do |tweet|
				tweet['entities']['user_mentions'].each do |um|
					expect(um['id']).to eq(42)
				end
			end
		end
		it 'Tweets que sao replies para tweets da locaweb devem estar na lista' do

			tweets = controller.get_eligible_tweets(controller.get_tweets_from_api('/mostrelevant'))

			tweets.each do |tweet|
				expect(tweet['in_reply_to_user_id']).to eq(42)
			end	
		end

	end

	context "Validar filtros de ordenacao Tweets" do 
		it 'Ordenar Tweets por maior numero de Seguidores' do
			controller.set_tweets(controller.get_eligible_tweets(controller.get_tweets_from_api('/mostrelevant')))
			tweets = controller.sort_tweets_by_criteria('1')
			tweets.each_with_index do |t, i|
				
				actual_element = t['user']['followers_count']  
				next_element = tweets[i+1]['user']['followers_count'] unless i == tweets.size - 1

				if next_element != nil
					expect(actual_element).to be >= next_element
				end

			end	
		end

		it 'Ordenar Tweets por maior numero de Favoritos' do
			controller.set_tweets(controller.get_eligible_tweets(controller.get_tweets_from_api('/mostrelevant')))
			tweets = controller.sort_tweets_by_criteria('2')
			tweets.each_with_index do |t, i|
				
				actual_element = t['favorite_count']  
				next_element = tweets[i+1]['favorite_count'] unless i == tweets.size - 1

				if next_element != nil
					expect(actual_element).to be >= next_element
				end
				
			end	
		end

		it 'Ordenar Tweets por maior numero de Retweets' do
			controller.set_tweets(controller.get_eligible_tweets(controller.get_tweets_from_api('/mostrelevant')))
			tweets = controller.sort_tweets_by_criteria('3')
			tweets.each_with_index do |t, i|
				
				actual_element = t['retweet_count']  
				next_element = tweets[i+1]['retweet_count'] unless i == tweets.size - 1

				if next_element != nil
					expect(actual_element).to be >= next_element
				end
				
			end	
		end
			
	end

end