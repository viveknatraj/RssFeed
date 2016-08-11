#encoding: UTF-8
xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @title
    xml.description "This is a blog of BBC news"
    xml.link 'http://feeds.bbci.co.uk/news/rss.xml'

    @blog_articles.each do |article|
      xml.item do
        xml.title article.title
        xml.description article.content
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link blog_article_url(article)
        xml.guid blog_article_url(article)
      end
    end
  end
end
