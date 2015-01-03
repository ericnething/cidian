# -*- coding: utf-8 -*-
require 'sinatra'
require 'json'
require 'haml'

def import_dictionary file
  JSON.parse File.read(file)
end

$dictionary = import_dictionary "cedict.json"
$keys = $dictionary.keys

def lookup query
  $dictionary[query]
end

def random_key
  # $keys[Random.rand ($keys.length + 1)]
  $keys.sample
end

def get_related query
  $keys.select { |item| item if item.include? query and item != query }
end

get "/" do
  redirect "/random"
end

get "/random" do
  query = random_key
  value = lookup query
  locals = {
    :key => query,
    :entries => value,
    :related => get_related(query)
  }
  haml :index, :format => :html5, :locals => locals
end

get "/lookup" do
  query = params[:query]
  value = lookup query
  locals = {
    :key => query,
    :entries => value,
    :related => get_related(query)
  }
  haml :index, :format => :html5, :locals => locals
end
