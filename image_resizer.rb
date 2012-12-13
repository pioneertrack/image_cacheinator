require 'rubygems'
require 'bundler/setup'
require 'goliath'

class ImageResizer < Goliath::API 

	use Goliath::Rack::Params
	use Goliath::Rack::Validation::RequestMethod %w(GET)
	use Goliath::Rack::Validation::RequiredParam { :key => 'url' }



	def response(env)
		url = PostRank::URI.clean(params['url'])
		hash = PostRank::URI.hash(url,:clean=>false)

		[200, {}, params.to_s]
	end
	
	
end
