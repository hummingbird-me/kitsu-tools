FactoryGirl.define do
  factory :anime do
    title          "Sword Art Online"
    age_rating     "PG-13 - Teens 13 or older"
    episode_count  25
    episode_length 23
    status         "Finished Airing"
    synopsis       "Description description description description"
    mal_id         11757
    youtube_video_id "Wv8u5bY8Now"
  end
  
  factory :producer do
    name "Aniplex"
  end
  
  factory :episode do
    anime
    number "1"
    title  "World of Swords"
  end

  factory :genre do
    name "Action"
  end
  
  factory :user do
    name "Vikhyat Korrapati"
    email "c@vikhyat.net"
    password "password"
    password_confirmation "password"
  end

  factory :episode_view do
    user
    anime
    episode
  end
end
