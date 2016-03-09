#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "TestBlog"
    xml.author "Ben Watson"
    xml.description "Testing RSS setup for Senior Seminar"
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
		# # if you like, do something with your content text here e.g. insert image tags.
		# # Optional. I'm doing this on my website.
    #     if article.image.exists?
    #         image_url = article.image.url(:large)
    #         image_caption = article.image_caption
    #         image_align = ""
    #         image_tag = "
    #             <p><img src='" + image_url +  "' alt='" + image_caption + "' title='" + image_caption + "' align='" + image_align  + "' /></p>
    #           "
    #         text = text.sub('{image}', image_tag)
    #     end
        xml.description "<p>" + text + "</p>"

      end
    end
  end
end
