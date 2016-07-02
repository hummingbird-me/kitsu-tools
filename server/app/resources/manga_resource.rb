class MangaResource < MediaResource
  attributes :manga_type

  # ElasticSearch hookup
  index MediaIndex::Manga
end
