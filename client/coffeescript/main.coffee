class DrinksList extends list.ListView
  className: 'list-view drink-list'

  generateItemElement: (item) ->
    $item = super
    $item.html $('<div class="drink-title">').text(item.get 'text')
    return $item

  clickItem: (m, ev) ->
    super
    @inspectModel?.set 'drink', m

class Drink extends Backbone.Model
  defaults: ->
    name: ''
    tags: []
    ingredients: []
    description: ''

$(document).ready ->
  $('body').html Handlebars.templates['main']()

  resultsBundle = list.bundle
    itemClass: Drink
    viewClass: DrinksList
  resultsBundle.view.render()

  searchBarBundle = search.bundle
    resultsModel: resultsBundle.model
  searchBarBundle.view.render()

  $('.search-panel').append searchBarBundle.view.$el
  $('.search-panel').append resultsBundle.view.$el

  inspectBundle = inspect.bundle()
  inspectBundle.view.render()

  $('.inspect-panel').append inspectBundle.view.$el

  # Glue.
  resultsBundle.view.inspectModel = inspectBundle.model

  tagRequest = $.ajax '/api/tags'
  tagRequest.done (data) ->
    searchBarBundle.tagsModel.set 'universe', data
