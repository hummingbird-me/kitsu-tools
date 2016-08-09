# == Route Map
#
#                                 Prefix Verb      URI Pattern                                                               Controller#Action
#       library_entry_relationships_user GET       /edge/library-entries/:library_entry_id/relationships/user(.:format)      library_entries#show_relationship {:relationship=>"user"}
#                                        PUT|PATCH /edge/library-entries/:library_entry_id/relationships/user(.:format)      library_entries#update_relationship {:relationship=>"user"}
#                                        DELETE    /edge/library-entries/:library_entry_id/relationships/user(.:format)      library_entries#destroy_relationship {:relationship=>"user"}
#                     library_entry_user GET       /edge/library-entries/:library_entry_id/user(.:format)                    users#get_related_resource {:relationship=>"user", :source=>"library_entries"}
#      library_entry_relationships_media GET       /edge/library-entries/:library_entry_id/relationships/media(.:format)     library_entries#show_relationship {:relationship=>"media"}
#                                        PUT|PATCH /edge/library-entries/:library_entry_id/relationships/media(.:format)     library_entries#update_relationship {:relationship=>"media"}
#                                        DELETE    /edge/library-entries/:library_entry_id/relationships/media(.:format)     library_entries#destroy_relationship {:relationship=>"media"}
#                    library_entry_media GET       /edge/library-entries/:library_entry_id/media(.:format)                   media#get_related_resource {:relationship=>"media", :source=>"library_entries"}
#                        library_entries GET       /edge/library-entries(.:format)                                           library_entries#index
#                                        POST      /edge/library-entries(.:format)                                           library_entries#create
#                          library_entry GET       /edge/library-entries/:id(.:format)                                       library_entries#show
#                                        PATCH     /edge/library-entries/:id(.:format)                                       library_entries#update
#                                        PUT       /edge/library-entries/:id(.:format)                                       library_entries#update
#                                        DELETE    /edge/library-entries/:id(.:format)                                       library_entries#destroy
#             anime_relationships_genres GET       /edge/anime/:anime_id/relationships/genres(.:format)                      anime#show_relationship {:relationship=>"genres"}
#                                        POST      /edge/anime/:anime_id/relationships/genres(.:format)                      anime#create_relationship {:relationship=>"genres"}
#                                        PUT|PATCH /edge/anime/:anime_id/relationships/genres(.:format)                      anime#update_relationship {:relationship=>"genres"}
#                                        DELETE    /edge/anime/:anime_id/relationships/genres(.:format)                      anime#destroy_relationship {:relationship=>"genres"}
#                           anime_genres GET       /edge/anime/:anime_id/genres(.:format)                                    genres#get_related_resources {:relationship=>"genres", :source=>"anime"}
#           anime_relationships_castings GET       /edge/anime/:anime_id/relationships/castings(.:format)                    anime#show_relationship {:relationship=>"castings"}
#                                        POST      /edge/anime/:anime_id/relationships/castings(.:format)                    anime#create_relationship {:relationship=>"castings"}
#                                        PUT|PATCH /edge/anime/:anime_id/relationships/castings(.:format)                    anime#update_relationship {:relationship=>"castings"}
#                                        DELETE    /edge/anime/:anime_id/relationships/castings(.:format)                    anime#destroy_relationship {:relationship=>"castings"}
#                         anime_castings GET       /edge/anime/:anime_id/castings(.:format)                                  castings#get_related_resources {:relationship=>"castings", :source=>"anime"}
#       anime_relationships_installments GET       /edge/anime/:anime_id/relationships/installments(.:format)                anime#show_relationship {:relationship=>"installments"}
#                                        POST      /edge/anime/:anime_id/relationships/installments(.:format)                anime#create_relationship {:relationship=>"installments"}
#                                        PUT|PATCH /edge/anime/:anime_id/relationships/installments(.:format)                anime#update_relationship {:relationship=>"installments"}
#                                        DELETE    /edge/anime/:anime_id/relationships/installments(.:format)                anime#destroy_relationship {:relationship=>"installments"}
#                     anime_installments GET       /edge/anime/:anime_id/installments(.:format)                              installments#get_related_resources {:relationship=>"installments", :source=>"anime"}
#           anime_relationships_mappings GET       /edge/anime/:anime_id/relationships/mappings(.:format)                    anime#show_relationship {:relationship=>"mappings"}
#                                        POST      /edge/anime/:anime_id/relationships/mappings(.:format)                    anime#create_relationship {:relationship=>"mappings"}
#                                        PUT|PATCH /edge/anime/:anime_id/relationships/mappings(.:format)                    anime#update_relationship {:relationship=>"mappings"}
#                                        DELETE    /edge/anime/:anime_id/relationships/mappings(.:format)                    anime#destroy_relationship {:relationship=>"mappings"}
#                         anime_mappings GET       /edge/anime/:anime_id/mappings(.:format)                                  mappings#get_related_resources {:relationship=>"mappings", :source=>"anime"}
#    anime_relationships_streaming_links GET       /edge/anime/:anime_id/relationships/streaming-links(.:format)             anime#show_relationship {:relationship=>"streaming_links"}
#                                        POST      /edge/anime/:anime_id/relationships/streaming-links(.:format)             anime#create_relationship {:relationship=>"streaming_links"}
#                                        PUT|PATCH /edge/anime/:anime_id/relationships/streaming-links(.:format)             anime#update_relationship {:relationship=>"streaming_links"}
#                                        DELETE    /edge/anime/:anime_id/relationships/streaming-links(.:format)             anime#destroy_relationship {:relationship=>"streaming_links"}
#                  anime_streaming_links GET       /edge/anime/:anime_id/streaming-links(.:format)                           streaming_links#get_related_resources {:relationship=>"streaming_links", :source=>"anime"}
#                            anime_index GET       /edge/anime(.:format)                                                     anime#index
#                                        POST      /edge/anime(.:format)                                                     anime#create
#                                  anime GET       /edge/anime/:id(.:format)                                                 anime#show
#                                        PATCH     /edge/anime/:id(.:format)                                                 anime#update
#                                        PUT       /edge/anime/:id(.:format)                                                 anime#update
#                                        DELETE    /edge/anime/:id(.:format)                                                 anime#destroy
#             manga_relationships_genres GET       /edge/manga/:manga_id/relationships/genres(.:format)                      manga#show_relationship {:relationship=>"genres"}
#                                        POST      /edge/manga/:manga_id/relationships/genres(.:format)                      manga#create_relationship {:relationship=>"genres"}
#                                        PUT|PATCH /edge/manga/:manga_id/relationships/genres(.:format)                      manga#update_relationship {:relationship=>"genres"}
#                                        DELETE    /edge/manga/:manga_id/relationships/genres(.:format)                      manga#destroy_relationship {:relationship=>"genres"}
#                           manga_genres GET       /edge/manga/:manga_id/genres(.:format)                                    genres#get_related_resources {:relationship=>"genres", :source=>"manga"}
#           manga_relationships_castings GET       /edge/manga/:manga_id/relationships/castings(.:format)                    manga#show_relationship {:relationship=>"castings"}
#                                        POST      /edge/manga/:manga_id/relationships/castings(.:format)                    manga#create_relationship {:relationship=>"castings"}
#                                        PUT|PATCH /edge/manga/:manga_id/relationships/castings(.:format)                    manga#update_relationship {:relationship=>"castings"}
#                                        DELETE    /edge/manga/:manga_id/relationships/castings(.:format)                    manga#destroy_relationship {:relationship=>"castings"}
#                         manga_castings GET       /edge/manga/:manga_id/castings(.:format)                                  castings#get_related_resources {:relationship=>"castings", :source=>"manga"}
#       manga_relationships_installments GET       /edge/manga/:manga_id/relationships/installments(.:format)                manga#show_relationship {:relationship=>"installments"}
#                                        POST      /edge/manga/:manga_id/relationships/installments(.:format)                manga#create_relationship {:relationship=>"installments"}
#                                        PUT|PATCH /edge/manga/:manga_id/relationships/installments(.:format)                manga#update_relationship {:relationship=>"installments"}
#                                        DELETE    /edge/manga/:manga_id/relationships/installments(.:format)                manga#destroy_relationship {:relationship=>"installments"}
#                     manga_installments GET       /edge/manga/:manga_id/installments(.:format)                              installments#get_related_resources {:relationship=>"installments", :source=>"manga"}
#           manga_relationships_mappings GET       /edge/manga/:manga_id/relationships/mappings(.:format)                    manga#show_relationship {:relationship=>"mappings"}
#                                        POST      /edge/manga/:manga_id/relationships/mappings(.:format)                    manga#create_relationship {:relationship=>"mappings"}
#                                        PUT|PATCH /edge/manga/:manga_id/relationships/mappings(.:format)                    manga#update_relationship {:relationship=>"mappings"}
#                                        DELETE    /edge/manga/:manga_id/relationships/mappings(.:format)                    manga#destroy_relationship {:relationship=>"mappings"}
#                         manga_mappings GET       /edge/manga/:manga_id/mappings(.:format)                                  mappings#get_related_resources {:relationship=>"mappings", :source=>"manga"}
#                            manga_index GET       /edge/manga(.:format)                                                     manga#index
#                                        POST      /edge/manga(.:format)                                                     manga#create
#                                  manga GET       /edge/manga/:id(.:format)                                                 manga#show
#                                        PATCH     /edge/manga/:id(.:format)                                                 manga#update
#                                        PUT       /edge/manga/:id(.:format)                                                 manga#update
#                                        DELETE    /edge/manga/:id(.:format)                                                 manga#destroy
#             drama_relationships_genres GET       /edge/drama/:drama_id/relationships/genres(.:format)                      dramas#show_relationship {:relationship=>"genres"}
#                                        POST      /edge/drama/:drama_id/relationships/genres(.:format)                      dramas#create_relationship {:relationship=>"genres"}
#                                        PUT|PATCH /edge/drama/:drama_id/relationships/genres(.:format)                      dramas#update_relationship {:relationship=>"genres"}
#                                        DELETE    /edge/drama/:drama_id/relationships/genres(.:format)                      dramas#destroy_relationship {:relationship=>"genres"}
#                           drama_genres GET       /edge/drama/:drama_id/genres(.:format)                                    genres#get_related_resources {:relationship=>"genres", :source=>"dramas"}
#           drama_relationships_castings GET       /edge/drama/:drama_id/relationships/castings(.:format)                    dramas#show_relationship {:relationship=>"castings"}
#                                        POST      /edge/drama/:drama_id/relationships/castings(.:format)                    dramas#create_relationship {:relationship=>"castings"}
#                                        PUT|PATCH /edge/drama/:drama_id/relationships/castings(.:format)                    dramas#update_relationship {:relationship=>"castings"}
#                                        DELETE    /edge/drama/:drama_id/relationships/castings(.:format)                    dramas#destroy_relationship {:relationship=>"castings"}
#                         drama_castings GET       /edge/drama/:drama_id/castings(.:format)                                  castings#get_related_resources {:relationship=>"castings", :source=>"dramas"}
#       drama_relationships_installments GET       /edge/drama/:drama_id/relationships/installments(.:format)                dramas#show_relationship {:relationship=>"installments"}
#                                        POST      /edge/drama/:drama_id/relationships/installments(.:format)                dramas#create_relationship {:relationship=>"installments"}
#                                        PUT|PATCH /edge/drama/:drama_id/relationships/installments(.:format)                dramas#update_relationship {:relationship=>"installments"}
#                                        DELETE    /edge/drama/:drama_id/relationships/installments(.:format)                dramas#destroy_relationship {:relationship=>"installments"}
#                     drama_installments GET       /edge/drama/:drama_id/installments(.:format)                              installments#get_related_resources {:relationship=>"installments", :source=>"dramas"}
#           drama_relationships_mappings GET       /edge/drama/:drama_id/relationships/mappings(.:format)                    dramas#show_relationship {:relationship=>"mappings"}
#                                        POST      /edge/drama/:drama_id/relationships/mappings(.:format)                    dramas#create_relationship {:relationship=>"mappings"}
#                                        PUT|PATCH /edge/drama/:drama_id/relationships/mappings(.:format)                    dramas#update_relationship {:relationship=>"mappings"}
#                                        DELETE    /edge/drama/:drama_id/relationships/mappings(.:format)                    dramas#destroy_relationship {:relationship=>"mappings"}
#                         drama_mappings GET       /edge/drama/:drama_id/mappings(.:format)                                  mappings#get_related_resources {:relationship=>"mappings", :source=>"dramas"}
#                            drama_index GET       /edge/drama(.:format)                                                     drama#index
#                                        POST      /edge/drama(.:format)                                                     drama#create
#                                  drama GET       /edge/drama/:id(.:format)                                                 drama#show
#                                        PATCH     /edge/drama/:id(.:format)                                                 drama#update
#                                        PUT       /edge/drama/:id(.:format)                                                 drama#update
#                                        DELETE    /edge/drama/:id(.:format)                                                 drama#destroy
#                                  users GET       /edge/users(.:format)                                                     users#index
#                                        POST      /edge/users(.:format)                                                     users#create
#                                   user GET       /edge/users/:id(.:format)                                                 users#show
#                                        PATCH     /edge/users/:id(.:format)                                                 users#update
#                                        PUT       /edge/users/:id(.:format)                                                 users#update
#                                        DELETE    /edge/users/:id(.:format)                                                 users#destroy
#  character_relationships_primary_media GET       /edge/characters/:character_id/relationships/primary-media(.:format)      characters#show_relationship {:relationship=>"primary_media"}
#                                        PUT|PATCH /edge/characters/:character_id/relationships/primary-media(.:format)      characters#update_relationship {:relationship=>"primary_media"}
#                                        DELETE    /edge/characters/:character_id/relationships/primary-media(.:format)      characters#destroy_relationship {:relationship=>"primary_media"}
#                character_primary_media GET       /edge/characters/:character_id/primary-media(.:format)                    primary_media#get_related_resource {:relationship=>"primary_media", :source=>"characters"}
#       character_relationships_castings GET       /edge/characters/:character_id/relationships/castings(.:format)           characters#show_relationship {:relationship=>"castings"}
#                                        POST      /edge/characters/:character_id/relationships/castings(.:format)           characters#create_relationship {:relationship=>"castings"}
#                                        PUT|PATCH /edge/characters/:character_id/relationships/castings(.:format)           characters#update_relationship {:relationship=>"castings"}
#                                        DELETE    /edge/characters/:character_id/relationships/castings(.:format)           characters#destroy_relationship {:relationship=>"castings"}
#                     character_castings GET       /edge/characters/:character_id/castings(.:format)                         castings#get_related_resources {:relationship=>"castings", :source=>"characters"}
#                             characters GET       /edge/characters(.:format)                                                characters#index
#                                        POST      /edge/characters(.:format)                                                characters#create
#                              character GET       /edge/characters/:id(.:format)                                            characters#show
#                                        PATCH     /edge/characters/:id(.:format)                                            characters#update
#                                        PUT       /edge/characters/:id(.:format)                                            characters#update
#                                        DELETE    /edge/characters/:id(.:format)                                            characters#destroy
#          person_relationships_castings GET       /edge/people/:person_id/relationships/castings(.:format)                  people#show_relationship {:relationship=>"castings"}
#                                        POST      /edge/people/:person_id/relationships/castings(.:format)                  people#create_relationship {:relationship=>"castings"}
#                                        PUT|PATCH /edge/people/:person_id/relationships/castings(.:format)                  people#update_relationship {:relationship=>"castings"}
#                                        DELETE    /edge/people/:person_id/relationships/castings(.:format)                  people#destroy_relationship {:relationship=>"castings"}
#                        person_castings GET       /edge/people/:person_id/castings(.:format)                                castings#get_related_resources {:relationship=>"castings", :source=>"people"}
#                                 people GET       /edge/people(.:format)                                                    people#index
#                                        POST      /edge/people(.:format)                                                    people#create
#                                 person GET       /edge/people/:id(.:format)                                                people#show
#                                        PATCH     /edge/people/:id(.:format)                                                people#update
#                                        PUT       /edge/people/:id(.:format)                                                people#update
#                                        DELETE    /edge/people/:id(.:format)                                                people#destroy
#            casting_relationships_media GET       /edge/castings/:casting_id/relationships/media(.:format)                  castings#show_relationship {:relationship=>"media"}
#                                        PUT|PATCH /edge/castings/:casting_id/relationships/media(.:format)                  castings#update_relationship {:relationship=>"media"}
#                                        DELETE    /edge/castings/:casting_id/relationships/media(.:format)                  castings#destroy_relationship {:relationship=>"media"}
#                          casting_media GET       /edge/castings/:casting_id/media(.:format)                                media#get_related_resource {:relationship=>"media", :source=>"castings"}
#        casting_relationships_character GET       /edge/castings/:casting_id/relationships/character(.:format)              castings#show_relationship {:relationship=>"character"}
#                                        PUT|PATCH /edge/castings/:casting_id/relationships/character(.:format)              castings#update_relationship {:relationship=>"character"}
#                                        DELETE    /edge/castings/:casting_id/relationships/character(.:format)              castings#destroy_relationship {:relationship=>"character"}
#                      casting_character GET       /edge/castings/:casting_id/character(.:format)                            characters#get_related_resource {:relationship=>"character", :source=>"castings"}
#           casting_relationships_person GET       /edge/castings/:casting_id/relationships/person(.:format)                 castings#show_relationship {:relationship=>"person"}
#                                        PUT|PATCH /edge/castings/:casting_id/relationships/person(.:format)                 castings#update_relationship {:relationship=>"person"}
#                                        DELETE    /edge/castings/:casting_id/relationships/person(.:format)                 castings#destroy_relationship {:relationship=>"person"}
#                         casting_person GET       /edge/castings/:casting_id/person(.:format)                               people#get_related_resource {:relationship=>"person", :source=>"castings"}
#                               castings GET       /edge/castings(.:format)                                                  castings#index
#                                        POST      /edge/castings(.:format)                                                  castings#create
#                                casting GET       /edge/castings/:id(.:format)                                              castings#show
#                                        PATCH     /edge/castings/:id(.:format)                                              castings#update
#                                        PUT       /edge/castings/:id(.:format)                                              castings#update
#                                        DELETE    /edge/castings/:id(.:format)                                              castings#destroy
#                                 genres GET       /edge/genres(.:format)                                                    genres#index
#                                        POST      /edge/genres(.:format)                                                    genres#create
#                                  genre GET       /edge/genres/:id(.:format)                                                genres#show
#                                        PATCH     /edge/genres/:id(.:format)                                                genres#update
#                                        PUT       /edge/genres/:id(.:format)                                                genres#update
#                                        DELETE    /edge/genres/:id(.:format)                                                genres#destroy
# streamer_relationships_streaming_links GET       /edge/streamers/:streamer_id/relationships/streaming-links(.:format)      streamers#show_relationship {:relationship=>"streaming_links"}
#                                        POST      /edge/streamers/:streamer_id/relationships/streaming-links(.:format)      streamers#create_relationship {:relationship=>"streaming_links"}
#                                        PUT|PATCH /edge/streamers/:streamer_id/relationships/streaming-links(.:format)      streamers#update_relationship {:relationship=>"streaming_links"}
#                                        DELETE    /edge/streamers/:streamer_id/relationships/streaming-links(.:format)      streamers#destroy_relationship {:relationship=>"streaming_links"}
#               streamer_streaming_links GET       /edge/streamers/:streamer_id/streaming-links(.:format)                    streaming_links#get_related_resources {:relationship=>"streaming_links", :source=>"streamers"}
#                              streamers GET       /edge/streamers(.:format)                                                 streamers#index
#                                        POST      /edge/streamers(.:format)                                                 streamers#create
#                               streamer GET       /edge/streamers/:id(.:format)                                             streamers#show
#                                        PATCH     /edge/streamers/:id(.:format)                                             streamers#update
#                                        PUT       /edge/streamers/:id(.:format)                                             streamers#update
#                                        DELETE    /edge/streamers/:id(.:format)                                             streamers#destroy
#  streaming_link_relationships_streamer GET       /edge/streaming-links/:streaming_link_id/relationships/streamer(.:format) streaming_links#show_relationship {:relationship=>"streamer"}
#                                        PUT|PATCH /edge/streaming-links/:streaming_link_id/relationships/streamer(.:format) streaming_links#update_relationship {:relationship=>"streamer"}
#                                        DELETE    /edge/streaming-links/:streaming_link_id/relationships/streamer(.:format) streaming_links#destroy_relationship {:relationship=>"streamer"}
#                streaming_link_streamer GET       /edge/streaming-links/:streaming_link_id/streamer(.:format)               streamers#get_related_resource {:relationship=>"streamer", :source=>"streaming_links"}
#     streaming_link_relationships_media GET       /edge/streaming-links/:streaming_link_id/relationships/media(.:format)    streaming_links#show_relationship {:relationship=>"media"}
#                                        PUT|PATCH /edge/streaming-links/:streaming_link_id/relationships/media(.:format)    streaming_links#update_relationship {:relationship=>"media"}
#                                        DELETE    /edge/streaming-links/:streaming_link_id/relationships/media(.:format)    streaming_links#destroy_relationship {:relationship=>"media"}
#                   streaming_link_media GET       /edge/streaming-links/:streaming_link_id/media(.:format)                  media#get_related_resource {:relationship=>"media", :source=>"streaming_links"}
#                        streaming_links GET       /edge/streaming-links(.:format)                                           streaming_links#index
#                                        POST      /edge/streaming-links(.:format)                                           streaming_links#create
#                         streaming_link GET       /edge/streaming-links/:id(.:format)                                       streaming_links#show
#                                        PATCH     /edge/streaming-links/:id(.:format)                                       streaming_links#update
#                                        PUT       /edge/streaming-links/:id(.:format)                                       streaming_links#update
#                                        DELETE    /edge/streaming-links/:id(.:format)                                       streaming_links#destroy
#   franchise_relationships_installments GET       /edge/franchises/:franchise_id/relationships/installments(.:format)       franchises#show_relationship {:relationship=>"installments"}
#                                        POST      /edge/franchises/:franchise_id/relationships/installments(.:format)       franchises#create_relationship {:relationship=>"installments"}
#                                        PUT|PATCH /edge/franchises/:franchise_id/relationships/installments(.:format)       franchises#update_relationship {:relationship=>"installments"}
#                                        DELETE    /edge/franchises/:franchise_id/relationships/installments(.:format)       franchises#destroy_relationship {:relationship=>"installments"}
#                 franchise_installments GET       /edge/franchises/:franchise_id/installments(.:format)                     installments#get_related_resources {:relationship=>"installments", :source=>"franchises"}
#                             franchises GET       /edge/franchises(.:format)                                                franchises#index
#                                        POST      /edge/franchises(.:format)                                                franchises#create
#                              franchise GET       /edge/franchises/:id(.:format)                                            franchises#show
#                                        PATCH     /edge/franchises/:id(.:format)                                            franchises#update
#                                        PUT       /edge/franchises/:id(.:format)                                            franchises#update
#                                        DELETE    /edge/franchises/:id(.:format)                                            franchises#destroy
#    installment_relationships_franchise GET       /edge/installments/:installment_id/relationships/franchise(.:format)      installments#show_relationship {:relationship=>"franchise"}
#                                        PUT|PATCH /edge/installments/:installment_id/relationships/franchise(.:format)      installments#update_relationship {:relationship=>"franchise"}
#                                        DELETE    /edge/installments/:installment_id/relationships/franchise(.:format)      installments#destroy_relationship {:relationship=>"franchise"}
#                  installment_franchise GET       /edge/installments/:installment_id/franchise(.:format)                    franchises#get_related_resource {:relationship=>"franchise", :source=>"installments"}
#        installment_relationships_media GET       /edge/installments/:installment_id/relationships/media(.:format)          installments#show_relationship {:relationship=>"media"}
#                                        PUT|PATCH /edge/installments/:installment_id/relationships/media(.:format)          installments#update_relationship {:relationship=>"media"}
#                                        DELETE    /edge/installments/:installment_id/relationships/media(.:format)          installments#destroy_relationship {:relationship=>"media"}
#                      installment_media GET       /edge/installments/:installment_id/media(.:format)                        media#get_related_resource {:relationship=>"media", :source=>"installments"}
#                           installments GET       /edge/installments(.:format)                                              installments#index
#                                        POST      /edge/installments(.:format)                                              installments#create
#                            installment GET       /edge/installments/:id(.:format)                                          installments#show
#                                        PATCH     /edge/installments/:id(.:format)                                          installments#update
#                                        PUT       /edge/installments/:id(.:format)                                          installments#update
#                                        DELETE    /edge/installments/:id(.:format)                                          installments#destroy
#            mapping_relationships_media GET       /edge/mappings/:mapping_id/relationships/media(.:format)                  mappings#show_relationship {:relationship=>"media"}
#                                        PUT|PATCH /edge/mappings/:mapping_id/relationships/media(.:format)                  mappings#update_relationship {:relationship=>"media"}
#                                        DELETE    /edge/mappings/:mapping_id/relationships/media(.:format)                  mappings#destroy_relationship {:relationship=>"media"}
#                          mapping_media GET       /edge/mappings/:mapping_id/media(.:format)                                media#get_related_resource {:relationship=>"media", :source=>"mappings"}
#                               mappings GET       /edge/mappings(.:format)                                                  mappings#index
#                                        POST      /edge/mappings(.:format)                                                  mappings#create
#                                mapping GET       /edge/mappings/:id(.:format)                                              mappings#show
#                                        PATCH     /edge/mappings/:id(.:format)                                              mappings#update
#                                        PUT       /edge/mappings/:id(.:format)                                              mappings#update
#                                        DELETE    /edge/mappings/:id(.:format)                                              mappings#destroy
#                                  lists GET       /edge/lists(.:format)                                                     lists#index
#                                        POST      /edge/lists(.:format)                                                     lists#create
#                                   list GET       /edge/lists/:id(.:format)                                                 lists#show
#                                        PATCH     /edge/lists/:id(.:format)                                                 lists#update
#                                        PUT       /edge/lists/:id(.:format)                                                 lists#update
#                                        DELETE    /edge/lists/:id(.:format)                                                 lists#destroy
#                                        GET       /oauth/authorize/:code(.:format)                                          doorkeeper/authorizations#show
#                    oauth_authorization GET       /oauth/authorize(.:format)                                                doorkeeper/authorizations#new
#                                        POST      /oauth/authorize(.:format)                                                doorkeeper/authorizations#create
#                                        DELETE    /oauth/authorize(.:format)                                                doorkeeper/authorizations#destroy
#                            oauth_token POST      /oauth/token(.:format)                                                    doorkeeper/tokens#create
#                           oauth_revoke POST      /oauth/revoke(.:format)                                                   doorkeeper/tokens#revoke
#                     oauth_applications GET       /oauth/applications(.:format)                                             doorkeeper/applications#index
#                                        POST      /oauth/applications(.:format)                                             doorkeeper/applications#create
#                  new_oauth_application GET       /oauth/applications/new(.:format)                                         doorkeeper/applications#new
#                 edit_oauth_application GET       /oauth/applications/:id/edit(.:format)                                    doorkeeper/applications#edit
#                      oauth_application GET       /oauth/applications/:id(.:format)                                         doorkeeper/applications#show
#                                        PATCH     /oauth/applications/:id(.:format)                                         doorkeeper/applications#update
#                                        PUT       /oauth/applications/:id(.:format)                                         doorkeeper/applications#update
#                                        DELETE    /oauth/applications/:id(.:format)                                         doorkeeper/applications#destroy
#          oauth_authorized_applications GET       /oauth/authorized_applications(.:format)                                  doorkeeper/authorized_applications#index
#           oauth_authorized_application DELETE    /oauth/authorized_applications/:id(.:format)                              doorkeeper/authorized_applications#destroy
#                       oauth_token_info GET       /oauth/token/info(.:format)                                               doorkeeper/token_info#show
#                                   root GET       /                                                                         home#index
#

Rails.application.routes.draw do
  scope '/edge' do
    jsonapi_resources :library_entries
    jsonapi_resources :anime
    jsonapi_resources :manga
    jsonapi_resources :drama
    jsonapi_resources :users
    jsonapi_resources :characters
    jsonapi_resources :people
    jsonapi_resources :castings
    jsonapi_resources :genres
    jsonapi_resources :streamers
    jsonapi_resources :streaming_links
    jsonapi_resources :franchises
    jsonapi_resources :installments
    jsonapi_resources :mappings
    jsonapi_resources :list
  end

  use_doorkeeper

  root to: 'home#index'
end
