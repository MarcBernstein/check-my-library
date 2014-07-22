class User < ActiveRecord::Base
	require 'goodreads'

	def self.create_with_omniauth(auth)
		create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.user_name = auth["info"]["user_name"]
			user.image_url = auth["extra"]["raw_info"]["image_url"]
			user.small_image_url = auth["extra"]["raw_info"]["small_image_url"]
			user.token = auth["credentials"]["token"]
			user.token_secret = auth["credentials"]["secret"]
			user.user_id = auth["extra"]["raw_info"]["id"]
			user.link = auth["extra"]["raw_info"]["link"]
    end
	end

	def get_to_read_shelf()
		Rails.logger = Logger.new(STDOUT)
		logger.debug self.token

		goodreads_client = Goodreads.new :oauth_token => self.token
		shelf = goodreads_client.shelf(self.user_id, 'to-read')
		shelf.total
	end

end
