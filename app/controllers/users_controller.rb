class UsersController < ApplicationController
	before_filter :must_be_signed_in, only: [:edit, :update]
	before_filter :must_be_correct_user, only: [:edit, :update]

	def new
		@user = User.new
	end

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to CorgiApp!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(params[:user])
			sign_in @user
			flash[:success] = "Information updated successfully!"
			redirect_to @user
		else
			render 'edit'
		end
	end

	private
		def must_be_signed_in
			store_location
			redirect_to signin_path, notice: "You must be signed in to access this page." unless signed_in?
		end

		def must_be_correct_user
			@user = User.find(params[:id])
			redirect_to root_path unless current_user?(@user)
		end
end
