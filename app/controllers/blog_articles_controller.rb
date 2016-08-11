require 'rss'
class BlogArticlesController < ApplicationController
  before_action :set_blog_article, only: [:show, :edit, :update, :destroy]

  # GET /blog_articles
  # GET /blog_articles.json
  def index
    @blog_articles = BlogArticle.all
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
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

  def populate_articles
    url = 'http://feeds.bbci.co.uk/news/rss.xml'
    count = 0
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        blog_article = BlogArticle.where(created_at: item.pubDate, title: item.title)
        unless blog_article.present?
          blog_article = BlogArticle.new
          blog_article.title = item.title 
          blog_article.content = item.description
          blog_article.created_at = item.pubDate
          blog_article.save
          count += 1
        end
      end
    end
    msg = count > 0 ? "Recent #{count} news fetched from BBC and saved to local DB" : 'No new news'
    render html: ("#{msg} <a href='/blog_articles.rss'>View Feeds</a>").html_safe
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_article
      @blog_article = BlogArticle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_article_params
      params.fetch(:blog_article).permit(:title, :content, :favorite)
    end
end
