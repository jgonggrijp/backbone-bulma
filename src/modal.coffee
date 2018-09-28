import { View, $ } from 'backbone'
import { defaults, noop, template as compile } from 'underscore'

template = '
    <div class="modal-background"></div>
    <% if (wrap === "content") { %>
        <div class="modal-content"></div>
    <% } else if (wrap === "card") { %>
        <div class="modal-card"></div>
    <% } %>
    <% if (allowClose) { %>
        <button class="modal-close is-large" aria-label="close"></button>
    <% } %>
'

export default class Modal extends View
    template: compile template
    tagName: 'div'
    className: 'modal'
    activeClass: 'is-active'

    defaultOptions:
        wrap: no
        allowClose: yes
        openInitially: no

    events:
        'click .modal-background, .modal-close': 'userClose'

    initialize: (options) ->
        defaults @, options, @defaultOptions
        @insertContent = switch @wrap
            when 'content' then @insertInContent
            when 'card' then @insertInCard
            else @insertDirectly
        @fetchContent = switch
            when @content?.el?
                # Backbone.View
                @fetchViewContent
            when @content?.get? or @content?.outerHTML?
                # HTML element, possibly wrapped in a jQuery
                @fetchElementContent
            when @content?.toUpperCase?
                # String
                @fetchStringContent
            else
                # no content
                @fetchTrivial
        @userCloseInternal = if @allowClose then @close else noop
        @render()
        if @openInitially then @open()

    render: ->
        @$el.html @template @
        @insertContent @fetchContent()
        @

    open: ->
        @$el.addClass @activeClass
        @

    close: ->
        @$el.removeClass @activeClass
        @

    toggle: ->
        @$el.toggleClass @activeClass
        @

    userClose: -> @userCloseInternal()

    insertInContent: (contentElement) ->
        @$('.modal-content').append contentElement

    insertInCard: (contentElement) ->
        @$('.modal-card').append contentElement

    insertDirectly: (contentElement) ->
        @$el.append contentElement

    fetchViewContent: -> @content.el

    fetchElementContent: -> @content

    fetchStringContent: -> $ @content

    fetchTrivial: -> $ '<div>'
