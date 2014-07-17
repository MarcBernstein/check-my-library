class User < ActiveRecord::Base

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

end