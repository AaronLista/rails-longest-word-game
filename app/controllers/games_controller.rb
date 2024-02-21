require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times { @grid << ('a'..'z').to_a.sample }
  end

  def score
    @grid = params[:grid].split('-')
    @attempt = params[:attempt]
    @valid_word = valid_word?(@grid, @attempt)
    @english_word = english_word?(@attempt)
    @score = 0
    @score = @attempt.length * 70 if (@valid_word && @english_word)
  end

  private

  def valid_word?(grid, attempt)
    grid_letters = grid.join.downcase
    attempt.split(//).each do |letter|
      if grid_letters.include?(letter)
        grid_letters[grid_letters.index(letter)] = '@'
      else
        return false
      end
    end
    return true
  end

  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    data_serealized = URI.open(url).read
    data = JSON.parse(data_serealized)
    data['found']
  end
end
