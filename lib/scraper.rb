require 'open-uri'
require 'pry' 
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
  	text = open(index_url).read
  	students = []
  	stud_hash = {}

  	parsed_text = Nokogiri::HTML(text)
  	parsed_text.css(".student-card").each do |student|
  		stud_hash[:name] = student.css(".student-name").text
  		stud_hash[:location] = student.css(".student-location").text
  		stud_hash[:profile_url] = student.css("a").attribute("href").value
  		students << stud_hash
  		stud_hash = {}
  	end
  	# binding.pry
    students
  end

  def self.scrape_profile_page(profile_url)
  	text = open(profile_url).read
    student = {}

    parsed_text = Nokogiri::HTML(text)
    parsed_text.css(".social-icon-container").css("a").each do |social|
    	url = social.attribute("href").value
    	case url
    		when /facebook/
    			student[:facebook] = url
    		when /linkedin/
    			student[:linkedin] = url
    		when /twitter/
    			student[:twitter] = url
    		when /github/
    			student[:github] = url
    		else 
    			student[:blog] = url
    	end
    	url = ""
    end
	student[:profile_quote] = parsed_text.css(".profile-quote").text
	student[:bio] = parsed_text.css(".bio-content.content-holder p").text
    student	
  end

end


Scraper.scrape_profile_page('./fixtures/student-site/students/aaron-enser.html')
