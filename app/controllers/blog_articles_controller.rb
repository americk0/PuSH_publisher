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

class BlogArticlesController < ApplicationController
  before_action :set_blog_article, only: [:show, :edit, :update, :destroy]

  # renders the rss feed when called
  # accessed by /feed
  def feed
    @blog_articles = BlogArticle.all
    respond_to do |format|
      format.rss { render layout: false }
    end
  end

  def test_xml
    str = '<?xml version="1.0" encoding="UTF-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom"><status feed="http://benjamin-watson-push-src.herokuapp.com/feed.rss" xmlns="http://superfeedr.com/xmpp-pubsub-ext"><http code="200">Fetched (ping) 200 86400 and parsed 1/14 entries</http><next_fetch>2016-03-03T21:51:44.489Z</next_fetch><entries_count_since_last_maintenance>24</entries_count_since_last_maintenance><velocity>1.8</velocity><generated_ids>true</generated_ids><period>86400</period><last_fetch>2016-03-02T21:51:44.360Z</last_fetch><last_parse>2016-03-02T21:51:44.366Z</last_parse><last_maintenance_at>2016-03-02T19:48:17.000Z</last_maintenance_at></status><link title="TestBlog" rel="alternate" href="https://benjamin-watson-push-src.herokuapp.com" type="text/html"/><link title="" rel="hub" href="https://benjamin-watson-senior-seminar.superfeedr.com/" type="text/html"/><link title="TestBlog" rel="self" href="http://benjamin-watson-push-src.herokuapp.com/feed.rss" type="application/rss+xml"/><title>TestBlog</title><updated>2016-03-02T21:51:35.000Z</updated><id>testblog-2016-3-2-21</id><entry xmlns="http://www.w3.org/2005/Atom" xmlns:geo="http://www.georss.org/georss" xmlns:as="http://activitystrea.ms/spec/1.0/" xmlns:sf="http://superfeedr.com/xmpp-pubsub-ext" xml:lang="en"><id>49</id><published>2016-03-02T21:51:35.000Z</published><updated>2016-03-02T21:51:35.000Z</updated><title>jbyiyifyugigdgbighvu</title><summary type="html">&lt;p&gt;kgkkl&lt;/p&gt;</summary><link title="jbyiyifyugigdgbighvu" rel="alternate" href="https://benjamin-watson-push-src.herokuapp.com/blog_articles/49" type="text/html"/><author><name>jkgouiyfy</name><uri></uri><email></email><id>jkgouiyfy</id></author></entry></feed>'

    # final = Hash.from_xml(str)['rss']['channel']['title'].to_yaml
    str.gsub!(/\n[ ]*/, '')
    doc = Nokogiri::XML(str)
    final = doc.xpath('.//entry').map do |node|
      node.xpath('./title').first.inner_text
    end
    final = final.inspect
    # final = doc.root.children[1].to_s
    respond_to do |format|
      format.html { render plain: doc.children.inspect, status: 200 }
    end
  end

  # GET /blog_articles
  # GET /blog_articles.json
  def index

    @blog_articles = BlogArticle.all
  end

  # GET /blog_articles/1
  # GET /blog_articles/1.json
  def show
  end

  # GET /blog_articles/new
  def new
    @blog_article = BlogArticle.new
  end

  # GET /blog_articles/1/edit
  def edit
  end

  # POST /blog_articles
  # POST /blog_articles.json
  def create
    @blog_article = BlogArticle.new(blog_article_params)

    respond_to do |format|
      if @blog_article.save
        uri = URI.parse 'http://benjamin-watson-senior-seminar.superfeedr.com/'
        post_params = {
          'hub.mode' => 'publish',
          'hub.url' => 'https://benjamin-watson-push-src.herokuapp.com/feed.rss',
        }
        Net::HTTP.post_form uri, post_params

        format.html { redirect_to @blog_article, notice: 'Blog article was successfully created.' }
        format.json { render :show, status: :created, location: @blog_article }
      else
        format.html { render :new }
        format.json { render json: @blog_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blog_articles/1
  # PATCH/PUT /blog_articles/1.json
  def update
    respond_to do |format|
      if @blog_article.update(blog_article_params)
        format.html { redirect_to @blog_article, notice: 'Blog article was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog_article }
      else
        format.html { render :edit }
        format.json { render json: @blog_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_articles/1
  # DELETE /blog_articles/1.json
  def destroy
    @blog_article.destroy
    respond_to do |format|
      format.html { redirect_to blog_articles_url, notice: 'Blog article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_article
      @blog_article = BlogArticle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_article_params
      params.require(:blog_article).permit(:title, :author, :text)
    end
end
