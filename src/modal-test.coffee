import { View, $ } from 'backbone'
import _ from 'underscore'
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
            it 'triggers on close button click', ->
                eventSpy = spyOnEvent 'button.modal-close', 'click'
                @modal.$('button').click()
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

    describe 'with jQuery content', ->
        beforeEach ->
            @modal = new Modal content: dummyContent.$el

        describe '.initialize', ->
            it 'sets @fetchContent: @fetchElementContent', ->
                expect(@modal.fetchContent).toBe @modal.fetchElementContent
            it 'does the default things otherwise', ->
                expect(@modal.wrap).toBe no
                expect(@modal.allowClose).toBe yes
                expect(@modal.openInitially).toBe no
                expect(@modal.insertContent).toBe @modal.insertDirectly
                expect(@modal.userCloseInternal).toBe @modal.close
                expect(@modal.$el).not.toBeEmpty()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

        describe '.render', ->
            beforeEach ->
                @rendered = @modal.render()
                @$el = @modal.$el
                @$ = @modal.$
            it 'behaves as in the default case', ->
                expect(@$el).toContainElement '.modal-background'
                expect(@$el).not.toContainElement '.modal-content'
                expect(@$el).not.toContainElement '.modal-card'
                expect(@$el).toContainElement 'button.modal-close'
                expect(@$el).toContainElement '#dummy'
                expect(@rendered).toBe @modal

        describe '.open', ->
            beforeEach ->
                @modal.close()
            it 'behaves as in the default case', ->
                @modal.open()
                expect(@modal.$el).toHaveClass @modal.activeClass

        describe '.close', ->
            beforeEach ->
                @modal.open()
                spyOn(@modal, 'userCloseInternal').and.callThrough()
                setFixtures sandbox()
                $('#sandbox').append @modal.el
            it 'behaves as in the default case', ->
                @modal.close()
                expect(@modal.$el).not.toHaveClass @modal.activeClass
                eventSpy = spyOnEvent '.modal-background', 'click'
                @modal.$('.modal-background').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()
                eventSpy = spyOnEvent 'button.modal-close', 'click'
                @modal.$('button').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()

        describe '.toggle', ->
            it 'behaves as in the default case', ->
                @modal.close()
                @modal.toggle()
                expect(@modal.$el).toHaveClass @modal.activeClass
                @modal.open()
                @modal.toggle()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

    describe 'with HTML element content', ->
        beforeEach ->
            @modal = new Modal content: dummyContent.el

        describe '.initialize', ->
            it 'sets @fetchContent: @fetchElementContent', ->
                expect(@modal.fetchContent).toBe @modal.fetchElementContent
            it 'does the default things otherwise', ->
                expect(@modal.wrap).toBe no
                expect(@modal.allowClose).toBe yes
                expect(@modal.openInitially).toBe no
                expect(@modal.insertContent).toBe @modal.insertDirectly
                expect(@modal.userCloseInternal).toBe @modal.close
                expect(@modal.$el).not.toBeEmpty()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

        describe '.render', ->
            beforeEach ->
                @rendered = @modal.render()
                @$el = @modal.$el
                @$ = @modal.$
            it 'behaves as in the default case', ->
                expect(@$el).toContainElement '.modal-background'
                expect(@$el).not.toContainElement '.modal-content'
                expect(@$el).not.toContainElement '.modal-card'
                expect(@$el).toContainElement 'button.modal-close'
                expect(@$el).toContainElement '#dummy'
                expect(@rendered).toBe @modal

        describe '.open', ->
            beforeEach ->
                @modal.close()
            it 'behaves as in the default case', ->
                @modal.open()
                expect(@modal.$el).toHaveClass @modal.activeClass

        describe '.close', ->
            beforeEach ->
                @modal.open()
                spyOn(@modal, 'userCloseInternal').and.callThrough()
                setFixtures sandbox()
                $('#sandbox').append @modal.el
            it 'behaves as in the default case', ->
                @modal.close()
                expect(@modal.$el).not.toHaveClass @modal.activeClass
                eventSpy = spyOnEvent '.modal-background', 'click'
                @modal.$('.modal-background').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()
                eventSpy = spyOnEvent 'button.modal-close', 'click'
                @modal.$('button').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()

        describe '.toggle', ->
            it 'behaves as in the default case', ->
                @modal.close()
                @modal.toggle()
                expect(@modal.$el).toHaveClass @modal.activeClass
                @modal.open()
                @modal.toggle()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

    describe 'with string content', ->
        beforeEach ->
            @modal = new Modal content: dummyContent.el.outerHTML

        describe '.initialize', ->
            it 'sets @fetchContent: @fetchStringContent', ->
                expect(@modal.fetchContent).toBe @modal.fetchStringContent
            it 'does the default things otherwise', ->
                expect(@modal.wrap).toBe no
                expect(@modal.allowClose).toBe yes
                expect(@modal.openInitially).toBe no
                expect(@modal.insertContent).toBe @modal.insertDirectly
                expect(@modal.userCloseInternal).toBe @modal.close
                expect(@modal.$el).not.toBeEmpty()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

        describe '.render', ->
            beforeEach ->
                @rendered = @modal.render()
                @$el = @modal.$el
                @$ = @modal.$
            it 'behaves as in the default case', ->
                expect(@$el).toContainElement '.modal-background'
                expect(@$el).not.toContainElement '.modal-content'
                expect(@$el).not.toContainElement '.modal-card'
                expect(@$el).toContainElement 'button.modal-close'
                expect(@$el).toContainElement '#dummy'
                expect(@rendered).toBe @modal

        describe '.open', ->
            beforeEach ->
                @modal.close()
            it 'behaves as in the default case', ->
                @modal.open()
                expect(@modal.$el).toHaveClass @modal.activeClass

        describe '.close', ->
            beforeEach ->
                @modal.open()
                spyOn(@modal, 'userCloseInternal').and.callThrough()
                setFixtures sandbox()
                $('#sandbox').append @modal.el
            it 'behaves as in the default case', ->
                @modal.close()
                expect(@modal.$el).not.toHaveClass @modal.activeClass
                eventSpy = spyOnEvent '.modal-background', 'click'
                @modal.$('.modal-background').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()
                eventSpy = spyOnEvent 'button.modal-close', 'click'
                @modal.$('button').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()

        describe '.toggle', ->
            it 'behaves as in the default case', ->
                @modal.close()
                @modal.toggle()
                expect(@modal.$el).toHaveClass @modal.activeClass
                @modal.open()
                @modal.toggle()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

    describe 'with no content', ->
        beforeEach ->
            @modal = new Modal()

        describe '.initialize', ->
            it 'sets @fetchContent: @fetchTrivial', ->
                expect(@modal.fetchContent).toBe @modal.fetchTrivial
            it 'does the default things otherwise', ->
                expect(@modal.wrap).toBe no
                expect(@modal.allowClose).toBe yes
                expect(@modal.openInitially).toBe no
                expect(@modal.insertContent).toBe @modal.insertDirectly
                expect(@modal.userCloseInternal).toBe @modal.close
                expect(@modal.$el).not.toBeEmpty()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

        describe '.render', ->
            beforeEach ->
                @rendered = @modal.render()
                @$el = @modal.$el
                @$ = @modal.$
            it 'inserts an empty <div>', ->
                expect(@$el).toContainElement 'div:not(.modal):not(.modal-background):not(.modal-content):not(.modal-card)'
            it 'does the default things otherwise', ->
                expect(@$el).toContainElement '.modal-background'
                expect(@$el).not.toContainElement '.modal-content'
                expect(@$el).not.toContainElement '.modal-card'
                expect(@$el).toContainElement 'button.modal-close'
                expect(@rendered).toBe @modal

        describe '.open', ->
            beforeEach ->
                @modal.close()
            it 'behaves as in the default case', ->
                @modal.open()
                expect(@modal.$el).toHaveClass @modal.activeClass

        describe '.close', ->
            beforeEach ->
                @modal.open()
                spyOn(@modal, 'userCloseInternal').and.callThrough()
                setFixtures sandbox()
                $('#sandbox').append @modal.el
            it 'behaves as in the default case', ->
                @modal.close()
                expect(@modal.$el).not.toHaveClass @modal.activeClass
                eventSpy = spyOnEvent '.modal-background', 'click'
                @modal.$('.modal-background').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()
                eventSpy = spyOnEvent 'button.modal-close', 'click'
                @modal.$('button').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()

        describe '.toggle', ->
            it 'behaves as in the default case', ->
                @modal.close()
                @modal.toggle()
                expect(@modal.$el).toHaveClass @modal.activeClass
                @modal.open()
                @modal.toggle()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

    describe 'with wrap: "content"', ->
        beforeEach ->
            @modal = new Modal content: dummyContent, wrap: 'content'

        describe '.initialize', ->
            it 'sets @wrap: "content"', ->
                expect(@modal.wrap).toBe 'content'
            it 'sets @insertContent: @insertInContent', ->
                expect(@modal.insertContent).toBe @modal.insertInContent
            it 'does the default things otherwise', ->
                expect(@modal.allowClose).toBe yes
                expect(@modal.openInitially).toBe no
                expect(@modal.fetchContent).toBe @modal.fetchViewContent
                expect(@modal.userCloseInternal).toBe @modal.close
                expect(@modal.$el).not.toBeEmpty()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

        describe '.render', ->
            beforeEach ->
                @rendered = @modal.render()
                @$el = @modal.$el
                @$ = @modal.$
            it 'creates a .modal-content wrapper element', ->
                expect(@$el).toContainElement '.modal-content'
                expect(@$el).not.toContainElement '.modal-card'
            it 'inserts the content element inside the wrapper', ->
                expect(@$ '.modal-content').toContainElement '#dummy'
            it 'does the default things otherwise', ->
                expect(@$el).toContainElement '.modal-background'
                expect(@$el).toContainElement 'button.modal-close'
                expect(@rendered).toBe @modal

        describe '.open', ->
            beforeEach ->
                @modal.close()
            it 'behaves as in the default case', ->
                @modal.open()
                expect(@modal.$el).toHaveClass @modal.activeClass

        describe '.close', ->
            beforeEach ->
                @modal.open()
                spyOn(@modal, 'userCloseInternal').and.callThrough()
                setFixtures sandbox()
                $('#sandbox').append @modal.el
            it 'behaves as in the default case', ->
                @modal.close()
                expect(@modal.$el).not.toHaveClass @modal.activeClass
                eventSpy = spyOnEvent '.modal-background', 'click'
                @modal.$('.modal-background').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()
                eventSpy = spyOnEvent 'button.modal-close', 'click'
                @modal.$('button').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()

        describe '.toggle', ->
            it 'behaves as in the default case', ->
                @modal.close()
                @modal.toggle()
                expect(@modal.$el).toHaveClass @modal.activeClass
                @modal.open()
                @modal.toggle()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

    describe 'with wrap: "card"', ->
        beforeEach ->
            @modal = new Modal content: dummyContent, wrap: 'card'

        describe '.initialize', ->
            it 'sets @wrap: "card"', ->
                expect(@modal.wrap).toBe 'card'
            it 'sets @insertContent: @insertInCard', ->
                expect(@modal.insertContent).toBe @modal.insertInCard
            it 'does the default things otherwise', ->
                expect(@modal.allowClose).toBe yes
                expect(@modal.openInitially).toBe no
                expect(@modal.fetchContent).toBe @modal.fetchViewContent
                expect(@modal.userCloseInternal).toBe @modal.close
                expect(@modal.$el).not.toBeEmpty()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

        describe '.render', ->
            beforeEach ->
                @rendered = @modal.render()
                @$el = @modal.$el
                @$ = @modal.$
            it 'creates a .modal-card wrapper element', ->
                expect(@$el).not.toContainElement '.modal-content'
                expect(@$el).toContainElement '.modal-card'
            it 'inserts the content element inside the wrapper', ->
                expect(@$ '.modal-card').toContainElement '#dummy'
            it 'does the default things otherwise', ->
                expect(@$el).toContainElement '.modal-background'
                expect(@$el).toContainElement 'button.modal-close'
                expect(@rendered).toBe @modal

        describe '.open', ->
            beforeEach ->
                @modal.close()
            it 'behaves as in the default case', ->
                @modal.open()
                expect(@modal.$el).toHaveClass @modal.activeClass

        describe '.close', ->
            beforeEach ->
                @modal.open()
                spyOn(@modal, 'userCloseInternal').and.callThrough()
                setFixtures sandbox()
                $('#sandbox').append @modal.el
            it 'behaves as in the default case', ->
                @modal.close()
                expect(@modal.$el).not.toHaveClass @modal.activeClass
                eventSpy = spyOnEvent '.modal-background', 'click'
                @modal.$('.modal-background').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()
                eventSpy = spyOnEvent 'button.modal-close', 'click'
                @modal.$('button').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()

        describe '.toggle', ->
            it 'behaves as in the default case', ->
                @modal.close()
                @modal.toggle()
                expect(@modal.$el).toHaveClass @modal.activeClass
                @modal.open()
                @modal.toggle()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

    describe 'with allowClose: no', ->
        beforeEach ->
            @modal = new Modal content: dummyContent, allowClose: no

        describe '.initialize', ->
            it 'sets @allowClose: no', ->
                expect(@modal.allowClose).toBe no
            it 'sets @userCloseInternal: _.noop', ->
                expect(@modal.userCloseInternal).toBe _.noop
            it 'does the default things otherwise', ->
                expect(@modal.wrap).toBe no
                expect(@modal.openInitially).toBe no
                expect(@modal.insertContent).toBe @modal.insertDirectly
                expect(@modal.fetchContent).toBe @modal.fetchViewContent
                expect(@modal.$el).not.toBeEmpty()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

        describe '.render', ->
            beforeEach ->
                @rendered = @modal.render()
                @$el = @modal.$el
                @$ = @modal.$
            it 'does not create a close button', ->
                expect(@$el).not.toContainElement 'button.modal-close'
            it 'does the default things otherwise', ->
                expect(@$el).toContainElement '.modal-background'
                expect(@$el).not.toContainElement '.modal-content'
                expect(@$el).not.toContainElement '.modal-card'
                expect(@$el).toContainElement '#dummy'
                expect(@rendered).toBe @modal

        describe '.open', ->
            beforeEach ->
                @modal.close()
            it 'behaves as in the default case', ->
                @modal.open()
                expect(@modal.$el).toHaveClass @modal.activeClass

        describe '.close', ->
            beforeEach ->
                @modal.open()
                spyOn(@modal, 'userCloseInternal').and.callThrough()
                setFixtures sandbox()
                $('#sandbox').append @modal.el
            it 'does not trigger on backdrop click', ->
                eventSpy = spyOnEvent '.modal-background', 'click'
                @modal.$('.modal-background').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.$el).toHaveClass @modal.activeClass
            it 'still removes the .is-active class', ->
                @modal.close()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

        describe '.toggle', ->
            it 'behaves as in the default case', ->
                @modal.close()
                @modal.toggle()
                expect(@modal.$el).toHaveClass @modal.activeClass
                @modal.open()
                @modal.toggle()
                expect(@modal.$el).not.toHaveClass @modal.activeClass

    describe 'with openInitially: yes', ->
        beforeEach ->
            @modal = new Modal content: dummyContent, openInitially: yes

        describe '.initialize', ->
            it 'sets @openInitially: yes', ->
                expect(@modal.openInitially).toBe yes
            it 'does call @open', ->
                expect(@modal.$el).toHaveClass @modal.activeClass
            it 'does the default things otherwise', ->
                expect(@modal.wrap).toBe no
                expect(@modal.allowClose).toBe yes
                expect(@modal.insertContent).toBe @modal.insertDirectly
                expect(@modal.fetchContent).toBe @modal.fetchViewContent
                expect(@modal.userCloseInternal).toBe @modal.close
                expect(@modal.$el).not.toBeEmpty()

        describe '.render', ->
            beforeEach ->
                @rendered = @modal.render()
                @$el = @modal.$el
                @$ = @modal.$
            it 'behaves as in the default case', ->
                expect(@$el).toContainElement '.modal-background'
                expect(@$el).not.toContainElement '.modal-content'
                expect(@$el).not.toContainElement '.modal-card'
                expect(@$el).toContainElement 'button.modal-close'
                expect(@$el).toContainElement '#dummy'
                expect(@rendered).toBe @modal

        describe '.open', ->
            beforeEach ->
                @modal.close()
            it 'behaves as in the default case', ->
                @modal.open()
                expect(@modal.$el).toHaveClass @modal.activeClass

        describe '.close', ->
            beforeEach ->
                @modal.open()
                spyOn(@modal, 'userCloseInternal').and.callThrough()
                setFixtures sandbox()
                $('#sandbox').append @modal.el
            it 'behaves as in the default case', ->
                @modal.close()
                expect(@modal.$el).not.toHaveClass @modal.activeClass
                eventSpy = spyOnEvent '.modal-background', 'click'
                @modal.$('.modal-background').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()
                eventSpy = spyOnEvent 'button.modal-close', 'click'
                @modal.$('button').click()
                expect(eventSpy).toHaveBeenTriggered()
                expect(@modal.userCloseInternal).toHaveBeenCalled()

        describe '.toggle', ->
            it 'behaves as in the default case', ->
                @modal.close()
                @modal.toggle()
                expect(@modal.$el).toHaveClass @modal.activeClass
                @modal.open()
                @modal.toggle()
                expect(@modal.$el).not.toHaveClass @modal.activeClass
