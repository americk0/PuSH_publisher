To see the tutorial for how to set up the client, go [here](https://github.com/americk0/PuSH_subscriber "PuSH subscriber")

# Set up the Publisher

This step is very easy since rails provides rss builder functionality to be able to generate an rss feed based on data in your models. Before you do all of this, you will need a rails app that has a model for blog articles (or in this case you might called them posts but I will refer to them as blog articles here) and a controller for the blog articles. The steps are as follows:

* Create a view called “feed.rss.builder” in the view folder for your blog articles with the following code. For right now, you can leave the colored links as they are. They will be changed in the next steps

```ruby
#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The name of your blog/website"
    xml.author "Your Name"
    xml.description "A description for your website"
    xml.link rel: "self", href: "https://benjamin-watson-push-src.herokuapp.com/feed.rss", type: "application/rss+xml"
    xml.link rel: "hub",  href: "https://benjamin-watson-senior-seminar.superfeedr.com/"
    xml.link "https://benjamin-watson-push-src.herokuapp.com"
    xml.language "en"

    for article in @blog_articles
      xml.item do
        if article.title
          xml.title article.title
        else
          xml.title ""
        end
        xml.author article.author
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link "https://benjamin-watson-push-src.herokuapp.com/blog_articles/" + article.id.to_s # + "-" + article.alias
        xml.guid article.id

        text = article.text
        xml.description "<p>" + text + "</p>"

      end
    end
  end
end
```

* In your blog articles controller (or whatever you call it) add a method called “feed” and put this code in it, replacing the yellow highlighted “BlogArticle” with whatever the name for your Posts model is. The “layout: false” part specifies that this page should not be rendered with the application layout (nav-bar, menu, etc.) like all the other pages.

```ruby
@blog_articles = BlogArticle.all
respond_to do |format|
  format.rss { render layout: false }
end
```

* In your config/routes.rb file, add a route called “feed” for the BlogArticles’ feed method. The line should look something like this:

```ruby
get “feed” => “blog_articles#feed”
```

* Go to superfeedr.com and create an account. Once you create an account, you will set up your hub and superfeedr will ask you to come up with a unique name for your hub and provide the feed url of your heroku app. At this time, your app may not yet be on heroku, so just come up with the unique name for the hub and remember that for the next step.
* Look back at your feed.rss.builder file. Replace the “benjamin-watson-senior-seminar” part of the blue url with whatever you chose as your hub name on superfeedr.
* Make a heroku app for your webpage like we have been doing in class for the homework and before you push, get the name of your heroku app and change the red, green, and purple urls in feed.rss.builder according to your heroku app name.
* Now app push your app to heroku. At this point your app is ready to be a publisher and all you need to do to finish is go back to the superfeedr page that was asking you to provide a hub name and your feed url, provide the feed url, and continue to finish your account. Superfeedr will check your feed url every 24 hours and send any new data to the subscribers. If you want the hub to send updates immediately after you make a post, you can add the following highlighted code into the “create” method of your BlogArticles controller. This will send a post request to the hub telling it that you have something new (note: you will need to change the urls to your urls).

```ruby
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
```
