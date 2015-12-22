module MediaSearch
  def filter_query(terms)
    {
      bool: {
        should: [
          { term: { characters: terms } },
          { term: { actors: terms } },
          { term: { 'titles.*' => terms } },
          {
            multi_match: {
              fields: %w[titles.* abbreviated_titles synopsis actors characters],
              query: terms,
              fuzziness: 2,
              max_expansions: 10,
              prefix_length: 2
            }
          }
        ],
        minimum_should_match: 1
      }
    }
  end

  def search_query(terms)
    {
      function_score: {
        field_value_factor: {
          field: 'user_count',
          modifier: 'log1p'
        },
        query: query(terms)
      }
    }
  end

  def filter(terms)
    AnimeIndex.query(filter_query(terms))
  end

  def search(terms)
    AnimeIndex.query(search_query(terms))
  end
end
