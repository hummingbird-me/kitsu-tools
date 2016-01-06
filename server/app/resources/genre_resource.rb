require 'unlimited_paginator'

class GenreResource < BaseResource
  attributes :name, :slug, :description

  paginator :unlimited
end
