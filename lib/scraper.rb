require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    array = []
    doc.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student| # . is for class
        s_name = student.css(".student-name").text
        s_location = student.css(".student-location").text
        s_profile = student.attr("href") # attr searches for "href" within 'student-card a'
        array << {:name => s_name, :location => s_location, :profile_url => s_profile}
      end
    end
    array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    attr_hash = {}
    if doc.css("div.social-icon-container a")
      doc.css("div.social-icon-container a").each do |link|
        if link.attr("href").include?("twitter")
          attr_hash[:twitter] = link.attr("href")
        elsif link.attr("href").include?("linkedin")
          attr_hash[:linkedin] = link.attr("href")
        elsif link.attr("href").include?("github")
          attr_hash[:github] = link.attr("href")
        else
          attr_hash[:blog] = link.attr("href")
        end
      end
    end
    attr_hash[:profile_quote] = doc.css("div.profile-quote").text
    attr_hash[:bio] = doc.css("div.description-holder p").text
    attr_hash
  end

end
