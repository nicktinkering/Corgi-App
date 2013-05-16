module UsersHelper

	# Returns a URI for the Gravatar image file of a given user.
	# Gravatars are based on a MD5 hash of an email.
	# I decline to use this. Instead, everyone on my site is a cat, drinking milk.
	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		return "https://secure.gravatar.com/avatar/#{gravatar_id}"
	end
end
