require 'set'

# Data structure for storing all users, items and ratings.
# Users and items are represented as strings, ratings are represented as floats.
class Ratings
  def initialize
    @users = Set.new
    @items = Set.new
    @user_indices = Hash.new
    @item_indices = Hash.new
    @user_ratings = Hash.new
    @item_ratings = Hash.new
    @min_rating = 1.0/0
    @max_rating = -1.0/0
  end
  
  def set_rating(user, item, rating)
    unless @users.include? user
      @user_indices[user] = @users.length
      @users.add user
    end
    unless @items.include? item
      @item_indices[item] = @items.length
      @items.add item
    end
    @min_rating = [@min_rating, rating].min
    @max_rating = [@max_rating, rating].max
    
    @user_ratings[user] ||= {}
    @user_ratings[user][item] = rating
    @item_ratings[item] ||= {}
    @item_ratings[item][user] = rating
  end
end
