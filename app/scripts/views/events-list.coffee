'use strict';

class MetaDash.Views.EventsListView extends Backbone.View
  template: MetaDash.JST['event-list']

  events:
    "click .event-row": "showDetails"

  initialize: (options)->
    @filter = options.filter
    @collection.on('sync', this.render, this)
    @collection.on('silencing', this.render, this)

  render: ->
    events = _.map(@collection.queryFilter(@filter), (event) -> event.toJSON({helperAttributes: true}))
    html = @template({ events: events })
    this.$el.html(html);

  showDetails: (evt) ->
    event = @collection.findWhere({id: $(evt.currentTarget).data('id')})
    if event
      client = event.getClient()
      check = event.getCheck()
      view = MetaDash.VM.create( this, 'EventModal', MetaDash.Views.EventModalView, {event: event, client: client, check: check})
      view.render()
