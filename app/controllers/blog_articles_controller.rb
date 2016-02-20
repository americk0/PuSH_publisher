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
