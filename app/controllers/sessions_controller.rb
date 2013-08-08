class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_email(params[:sessions][:email])
		if user && user.authenticate(params[:sessions][:password])

		# Sign the user in and redirect to the user's show page.
			sign_in user
			redirect_back_or user
		else
			flash.now[:error] =  "Invalid Email / Password"
			render 'new'
			# Create an error message and re-render the signin form.
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
