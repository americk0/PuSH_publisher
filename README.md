To see the tutorial for how to set up the subscriber, go [here](https://github.com/americk0/PuSH_subscriber "PuSH subscriber")

# Set up the Publisher

Setting up a publisher is very easy since rails provides rss builder functionality to be able to generate an rss feed based on data in your models. Also note that most of the time, a publisher will only be a publisher and a subscriber will only be a subscriber. This example shows how to implement only the publisher, but in class each group’s website will be both a publisher and a subscriber. Refer to the link at the top to see how to implement the subscriber.

* Before you do all of this, you will need a model for blog articles (or in this case you might called them posts but I will refer to them as blog articles here) and a controller for the blog articles. This can be generated with the following rails command:

```bash
rails generate scaffold blog_article title:string author:string text:text
```

* Create a view called “feed.rss.builder” in the view folder for your blog articles with the following code. For right now, you can leave the links as they are. They will need to be changed in the next steps

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

* In your blog articles controller add a method called “feed” and put the following code in it. Note: The “layout: false” part specifies that this page should not be rendered with the application layout (nav-bar, menu, etc.) like all the other pages.

```ruby
@blog_articles = BlogArticle.all
respond_to do |format|
  format.rss { render layout: false }
end
```

* In your config/routes.rb file, add a route called “feed” for the blog article controller's feed method. The line should look something like this:

```ruby
get “feed” => “blog_articles#feed”
```

* Go to superfeedr.com and create an account. Once you create an account, you will need to set up your hub and superfeedr will ask you to come up with a unique name for your hub and provide the feed url for your RSS feed. At this time, your app may not yet be on heroku, so just come up with the unique name for the hub and use what you think will be the full url of your feed once your app is on heroku (heroku will assign you a random name but you can change it with the `heroku rename command`)

* Look back at your feed.rss.builder file. Change the “benjamin-watson-senior-seminar.superfeedr.com” url to use whatever you chose as your hub name on superfeedr. Now push to heroku like we have been doing in class and change the urls in feed.rss.builder that have my app name to have your heroku app name instead.

* Once you have done this, your app is ready to be a publisher. Superfeedr will check your feed url every 24 hours and send any new data to the subscribers, but if you want the hub to send updates immediately after you make a blog article, you can add the following code into the “create” method of your blog articles controller. This will send a post request to the hub telling it that you have something new as soon as you create a new blog article (note: you will need to change the urls to your urls).

```ruby
def create
  @blog_article = BlogArticle.new(blog_article_params)

  respond_to do |format|
    if @blog_article.save

      # add this code
      uri = URI.parse 'http://benjamin-watson-senior-seminar.superfeedr.com/'
      post_params = {
        'hub.mode' => 'publish',
        'hub.url' => 'https://benjamin-watson-push-src.herokuapp.com/feed.rss',
      }
      Net::HTTP.post_form uri, post_params
      ###########

      format.html { redirect_to @blog_article, notice: 'Blog article was successfully created.' }
      format.json { render :show, status: :created, location: @blog_article }
    else
      format.html { render :new }
      format.json { render json: @blog_article.errors, status: :unprocessable_entity }
    end
  end
end
```

* Now your publisher is ready
