class UsersController < ApplicationController
	before_filter :authenticate_user!
	before_filter :correct_user?, :except => [:index]

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def show_to_read_shelf
		@user = User.find(params[:id])
		@user.get_to_read_shelf
	end

end
