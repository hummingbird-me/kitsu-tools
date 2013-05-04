# Ikaros

Hummingbird's awesome new recommendation engine.

## API

* `PutRatings(user_id, [(item_id, rating)])`
* `GetSimilarItems(item_id)`
* `GetUserRecommendations(user_id)`
* `GetItemRecommendations([item_id])`
* `GetUserSimilarity(user1_id, user2_id)`

## Notes

* API will serve and accept JSON over HTTP.
* It won't be RESTful, though.
* API provider will be restarted *with downtime* during deploys. The clients need to be written in a way that will make this invisible to the calling application.

## Concerns

* Where will the rating data/latent factors be stored?
* Concurrency? v1 doesn't need to be concurrent, but what about the future?

## Implementation Plan

1. Implement `GetSimilarItems` and use it in the recommendation system. At this stage just act as a proxy to `anime_safari` on `neko`. Deploy in production -- this involves setting up Graphite, Riemann etc.
2. Implement `GetItemRecommendations` and transition over to that.
