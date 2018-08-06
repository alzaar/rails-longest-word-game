require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    letters = ("A".."Z").to_a
    @grid = []
    10.times { @grid << letters.sample }
    @total_score = cookies[:total_score]
    return @grid
  end

  def score
    @grid = params[:grid]
    @guess = params[:guess]
    @start_time = DateTime.parse(params[:start_time])
    @score = 0
    @message = "Not an english word"
    @end_time = Time.now
    @time_taken = (@end_time - @start_time).round
    if @time_taken == 1
      @time_taken = @time_taken.to_s + " second"
    else
      @time_taken = @time_taken.to_s + " seconds"
    end
    if JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@guess}").read)['found'].to_s == "true"
      @message = "well done"
      @time_taken.to_i < 10 ? @score = 1 + @guess.length : @score = @guess.length
    end
    @guess.upcase.split("").each do |letter|
      unless @grid.include?(letter) && @guess.upcase.count(letter) <= @grid.count(letter)
        @message = "not in the grid"
        @score = 0
      end
    end
    @total_score = @total_score.to_i
    @total_score += @score
    cookies[:total_score] = @total_score
  end
end
