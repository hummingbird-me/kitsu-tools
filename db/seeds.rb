# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

GENRES = [ 'Action', 'Adventure', 'Comedy', 'Drama', 'Sci-Fi', 'Space',
           'Mystery', 'Magic', 'Supernatural', 'Police', 'Fantasy', 'Sports',
           'Romance', 'Slice of Life', 'Cars', 'Horror', 'Psychological',
           'Thriller', 'Martial Arts', 'Super Power', 'School', 'Ecchi',
           'Vampire', 'Historical', 'Military', 'Dementia', 'Mecha', 'Demons',
           'Samurai', 'Harem', 'Music', 'Parody', 'Shoujo Ai', 'Game',
           'Shounen Ai', 'Kids', 'Hentai', 'Yuri', 'Yaoi', 'Anime Influenced' ]
GENRES.each { |g| Genre.create(name: g) }
