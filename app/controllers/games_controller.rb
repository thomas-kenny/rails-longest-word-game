require 'open-uri'
ActionDispatch::Session::CacheStore

class GamesController < ApplicationController
  def new
    grid
  end

  def score
    @letters = params[:letters].split(' ')
    @word = (params[:word] || '').upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    if @included
      sum = 0
      if @english_word
        @score = "Well done, '#{@word}' is a valid entry! Your score is #{sum += @word.length}"
      else
        @score = "'#{@word}' not in the English dictionary"
      end
    else
      @score = "'#{@word}'' can not be made using the letters #{@letters.join}"
    end
  end

  private

  def grid
    alphabet = ('A'..'Z').to_a
    @letters = alphabet.sample(10)
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url).read
    data = JSON.parse(response)
    data['found']
  end

  def included?(word, letters)
    word.chars.all? do |letter|
      word.count(letter) <= letters.count(letter)
    end
  end
end
