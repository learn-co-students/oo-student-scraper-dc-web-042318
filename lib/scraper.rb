require 'open-uri'

class Scraper
  
  def self.scrape_index_page(index_url)
    index = Nokogiri::HTML(File.read(index_url))
    array = []
    index.css('div.student-card').each do |student|
      index_hash = 
      { :name => student.css('h4.student-name').text, :location => student.css('p.student-location').text, :profile_url => student.css('a').attribute('href').value }
      array << index_hash
    end
    array
  end
  
  def self.convert_to_link(data)
    data.attribute('href').value
  end
  
  def self.check_link(href)
    link = self.convert_to_link(href)
    return :twitter if link.include?('twitter.com')
    return :linkedin if link.include?('linkedin.com')
    return :github if link.include?('github.com')
    return :blog  if href.children.css('img.social-icon').attribute('src').value.include?('rss')
  end
  
  def self.scrape_profile_page(profile_url)
    student_hash = {}
    student_page = Nokogiri::HTML(File.read(profile_url))
    student_page.css('div.social-icon-container a').each do |href|
      link = convert_to_link(href)
      student_hash[self.check_link(href)] = link
    end
    student_hash[:profile_quote] = student_page.css('div.profile-quote').text
    student_hash[:bio] = student_page.css('div.description-holder p').text.split.join(' ')
    student_hash
  end
end
