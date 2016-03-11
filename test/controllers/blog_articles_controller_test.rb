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

require 'test_helper'

class BlogArticlesControllerTest < ActionController::TestCase
  setup do
    @blog_article = blog_articles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blog_articles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blog_article" do
    assert_difference('BlogArticle.count') do
      post :create, blog_article: { author: @blog_article.author, text: @blog_article.text, title: @blog_article.title }
    end

    assert_redirected_to blog_article_path(assigns(:blog_article))
  end

  test "should show blog_article" do
    get :show, id: @blog_article
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blog_article
    assert_response :success
  end

  test "should update blog_article" do
    patch :update, id: @blog_article, blog_article: { author: @blog_article.author, text: @blog_article.text, title: @blog_article.title }
    assert_redirected_to blog_article_path(assigns(:blog_article))
  end

  test "should destroy blog_article" do
    assert_difference('BlogArticle.count', -1) do
      delete :destroy, id: @blog_article
    end

    assert_redirected_to blog_articles_path
  end
end
