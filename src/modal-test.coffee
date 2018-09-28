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
