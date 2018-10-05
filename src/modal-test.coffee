import { View, $ } from 'backbone'
import 'jasmine-jquery'

import Modal from './modal'

dummyContent = new View id: 'dummy'

describe 'Modal', ->
    afterEach ->
        dummyContent.$el.html ''

    describe 'with default options', ->
        beforeEach ->
            @modal = new Modal content: dummyContent

        describe '.initialize', ->
            it 'sets @wrap: no', ->
                expect(@modal.wrap).toBe no
            it 'sets @allowClose: yes', ->
                expect(@modal.allowClose).toBe yes
            it 'sets @openInitially: no', ->
                expect(@modal.openInitially).toBe no
            it 'sets @insertContent: @insertDirectly', ->
                expect(@modal.insertContent).toBe @modal.insertDirectly
            it 'sets @fetchContent: @fetchViewContent', ->
                expect(@modal.fetchContent).toBe @modal.fetchViewContent
            it 'sets @userCloseInternal: @close', ->
                expect(@modal.userCloseInternal).toBe @modal.close
            it 'calls @render', ->
                expect(@modal.$el).not.toBeEmpty()
            it 'does not call @open', ->
                expect(@modal.$el).not.toHaveClass @modal.activeClass

        describe '.render', ->
            beforeEach ->
                @rendered = @modal.render()
                @$el = @modal.$el
                @$ = @modal.$
            it 'creates a modal backdrop', ->
                expect(@$el).toContainElement '.modal-background'
            it 'does not create wrapper elements', ->
                expect(@$el).not.toContainElement '.modal-content'
                expect(@$el).not.toContainElement '.modal-card'
            it 'does create a close button', ->
                expect(@$el).toContainElement 'button.modal-close'
            it 'inserts the content element', ->
                expect(@$el).toContainElement '#dummy'
            it 'returns itself', ->
                expect(@rendered).toBe @modal

        describe '.open', ->
            beforeEach ->
                @modal.close()
            it 'adds the .is-active class', ->
                @modal.open()
                expect(@modal.$el).toHaveClass @modal.activeClass

        describe '.close', ->
            beforeEach ->
                @modal.open()
                spyOn(@modal, 'userCloseInternal').and.callThrough()
                setFixtures sandbox()
                $('#sandbox').append @modal.el
            it 'removes the .is-active class', ->
                @modal.close()
                expect(@modal.$el).not.toHaveClass @modal.activeClass
            it 'triggers on backdrop click', ->
                eventSpy = spyOnEvent '.modal-background', 'click'
                @modal.$('.modal-background').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()

        describe '.toggle', ->
            it 'adds the .is-active class when closed', ->
                @modal.close()
                @modal.toggle()
                expect(@modal.$el).toHaveClass @modal.activeClass
            it 'removes the .is-active class when open', ->
                @modal.open()
                @modal.toggle()
                expect(@modal.$el).not.toHaveClass @modal.activeClass
