require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @letters = params[:letters].split
    @word = params[:word]

    if grid?(@word, @letters) && exists?(@word) == false
      @result = "Sorry but #{@word.upcase} is nos an English word"
    elsif grid?(@word, @letters) == false && exists?(@word)
      @result = "Sorry but #{@word.upcase} can't be build out of #{@letters.join(', ').upcase}"
    elsif grid?(@word, @letters) == false && exists?(@word) == false
      @result = "Sorry but #{@word.upcase} is not an English word
                and it can't be build out of #{@letters.join(', ').upcase}"
    else
      @result = "#{@word.upcase} is a great word!!"
    end
  end

  private

  def grid?(word, letters)
    word.chars.all? { |character| letters.include?(character) }
  end

  def exists?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
