class Comment < ActiveRecord::Base
	belongs_to :article

	validates_presence_of :name, :email, :body
	validate :article_should_be_published

	after_create :send_comment_email

	def article_should_be_published
		errors.add(:article_id, I18n.t('comments.errors.not_published_yet')) if article && !article.published?
	end

	def send_comment_email
		Notifier.comment_added(self).deliver
	end
end
