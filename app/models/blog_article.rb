# == Schema Information
#
# Table name: blog_articles
#
#  id         :integer          not null, primary key
#  title      :string
#  author     :string
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BlogArticle < ActiveRecord::Base
end
