require 'digest'
class User < ActiveRecord::Base
	attr_accessor :password
	has_many :articles, -> { order('published_at DESC', 'title ASC') }, dependent: :nullify
	has_one :profile
	has_many :replies, through: :articles, source: :comments

	validates :password, length: { within: 4..20 }
	validates_presence_of :password, if: :password_required?
	validates :email, uniqueness: true, 
						length: { within: 5..50 }
	validates_format_of :email, :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i, multiline: true
	validates_confirmation_of :password

	before_save :encrypt_new_password

	def self.authenticate(email, password)
		user = find_by_email(email)
		return user if user && user.authenticated?(password)
	end

	def authenticated?(password)
		self.hashed_password == encrypt(password)
	end

	protected

		def encrypt_new_password
			return if password.blank?
			self.hashed_password = encrypt(password)
		end

		def password_required?
			hashed_password.blank? || password.present?
		end

		def encrypt(string)
			Digest::SHA1.hexdigest(string)
		end
end
