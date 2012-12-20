require 'rubygems'
require 'bundler/setup'
require 'goliath'
require 'postrank-uri'
require 'em-synchrony'
require 'em-synchrony/em-http'

class ImageResizer < Goliath::API 

	use Goliath::Rack::Params
	use Goliath::Rack::Validation::RequestMethod, %w(GET)
	use Goliath::Rack::Validation::RequiredParam, { :key => 'url' }
	use Goliath::Rack::Validation::RequiredParam, { :key => 'geometry' }

	def response(env)
		url = PostRank::URI.clean(params['url'])
                geometry = CGI::escape(params['geometry'])
                escaped_url = CGI::escape(url)
		hash = PostRank::URI.hash(url + geometry, :clean=>false)

                if !File.exists? filename(hash)

                  fiber = Fiber.current
                  puts './convert.rb "' + escaped_url + '" ' + filename(hash) + ' ' + geometry
                  EM.system('./convert.rb "' + escaped_url + '" ' + filename(hash) + ' ' + geometry) do |output, status|
                    env.logger.info "convert status #{status}"
                    fiber.resume
                  end
                  Fiber.yield

                end


		[200, {},  IO.read(filename(hash))]
	end
	
        def filename(hash)
            "resized_images/#{hash}.png"
        end
          
	
end
