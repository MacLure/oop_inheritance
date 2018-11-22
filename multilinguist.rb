require 'httparty'
require 'json'


# This class represents a world traveller who knows what languages are spoken in each country
# around the world and can cobble together a sentence in most of them (but not very well)
class Multilinguist

  TRANSLTR_BASE_URL = "http://bitmakertranslate.herokuapp.com"
  COUNTRIES_BASE_URL = "https://restcountries.eu/rest/v2/name"
  #{name}?fullText=true
  #?text=The%20total%20is%2020485&to=ja&from=en


  # Initializes the multilinguist's @current_lang to 'en'
  #
  # @return [Multilinguist] A new instance of Multilinguist
  def initialize
    @current_lang = 'en'
  end

  # Uses the RestCountries API to look up one of the languages
  # spoken in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] A 2 letter iso639_1 language code
  def language_in(country_name)
    params = {query: {fullText: 'true'}}
    response = HTTParty.get("#{COUNTRIES_BASE_URL}/#{country_name}", params)
    json_response = JSON.parse(response.body)
    json_response.first['languages'].first['iso639_1']
  end

  # Sets @current_lang to one of the languages spoken
  # in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] The new value of @current_lang as a 2 letter iso639_1 code
  def travel_to(country_name)
    local_lang = language_in(country_name)
    @current_lang = local_lang
  end

  # (Roughly) translates msg into @current_lang using the Transltr API
  #
  # @param msg [String] A message to be translated
  # @return [String] A rough translation of msg
  def say_in_local_language(msg)
    params = {query: {text: msg, to: @current_lang, from: 'en'}}
    response = HTTParty.get(TRANSLTR_BASE_URL, params)
    json_response = JSON.parse(response.body)
    json_response['translationText']
  end
end

class MathGenius < Multilinguist

  def initialize
    super
  end

  def report_total(array)
    return("The total is #{array.reduce(:+)}")
  end

  def get_odds(array)
    output = []
    array.each do |item|
      if item % 2 != 0
        output << item
      end
    end
    return output
  end


end

class Quote_collector

  def initialize
    super
    @quotes = []
    @topics = ["wisdom", "friendship"]
  end

  def add_quote(quote, topic)
    @quotes << {:quote => quote, :topic => topic}
  end

  def give_random_quote(topic)
    topic_quotes = []
    @quotes.each do |item|
      if item[:topic] == topic
        topic_quotes << item[:quote]
      end
    end
    return topic_quotes
  end

end

class Third_class < Multilinguist

  def initialize
    super
  end


end



me = MathGenius.new
puts me.report_total([23,45,676,34,5778,4,23,5465]) # The total is 12048
me.travel_to("India")
puts me.report_total([6,3,6,68,455,4,467,57,4,534]) # है को कुल 1604
me.travel_to("Italy")
puts me.report_total([324,245,6,343647,686545]) # È Il totale 1030767
puts '-------------'
p me.get_odds([23,45,676,34,5778,4,23,5465])
p me.get_odds([6,3,6,68,455,4,467,57,4,534]) 
p me.get_odds([324,245,6,343647,686545])

puts '-------------'
me_again = Quote_collector.new
me_again.add_quote("life is like a box of chocolates", "wisdom")
me_again.add_quote("live long and prosper", "friendship")
me_again.add_quote("The way that can be named is not the true way", "wisdom")
me_again.add_quote("oh hai mark", "friendship")
puts me_again.give_random_quote("wisdom")
puts '-------------'
puts me_again.give_random_quote("friendship")

