Rails.application.routes.draw do

	root "index#home"
	get "mostmention" => "index#mostmention" 
	get "mostrelevant" => "index#mostrelevant" 
	get "reload" => "index#home"
	get "tweet" => "index#tweet"
	get "showjson" => "index#showjson"

end
