class UsersIndex < Chewy::Index
  define_type User do
    field :name
    field :past_names
  end
end
