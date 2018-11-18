# frozen_string_literal: true

require 'slack-buggybot/models/bug'
require 'slack-buggybot/models/event'

describe SlackBuggybot::Bug do
  before(:each) do
    @event = SlackBuggybot::Event.new(start: Time.now.utc, owner: OWNER_ID, channel_id: CHANNEL_ID)
  end

  describe 'instances methods' do
    it '#assign sets the assignee and state' do
      subject = SlackBuggybot::Bug.new(event_id: @event.id, url: 'http://example.com').save
      subject.assign(user_id: USER_ID)

      expect(subject.assignee).to eq(USER_ID)
      expect(subject.state).to eq('wip')
    end
  end

  describe 'class methods' do
    describe 'with existing bugs in the db' do
      before(:each) do
        @bugs = Array.new(10).map do
          SlackBuggybot::Bug.new(event_id: @event.id, url: 'http://example.com')
        end
        @bugs[0].assign(user_id: USER_ID)
        @bugs[1].update(assignee: USER_ID, completed: Time.now.utc, state: 'fixed')
        @bugs[2].update(assignee: USER_ID, completed: Time.now.utc, state: 'added_docs')
        @bugs[3].update(assignee: USER_ID, completed: Time.now.utc, state: 'verified')
        @bugs.map(&:save)
      end

      it '#in_event has correct count' do
        expect(SlackBuggybot::Bug.in_event(@event.id).count) == 10
      end

      it '#ready_in_event has correct count' do
        expect(SlackBuggybot::Bug.ready_in_event(@event.id).count) == 6
      end

      it '#remaining_in_event has correct count' do
        expect(SlackBuggybot::Bug.remaining_in_event(@event.id).count) == 7
      end

      it '#done_in_event has correct count' do
        expect(SlackBuggybot::Bug.done_in_event(@event.id).count) == 3
      end

      it '#user_existing_bug returns the correct bug' do
        expect(SlackBuggybot::Bug.user_existing_bug(user_id: USER_ID, event_id: @event.id))
      end

      it '#user_finished_bugs has correct count' do
        expect(SlackBuggybot::Bug.user_finished_bugs(user_id: USER_ID, event_id: @event.id).count) == 3
      end
    end
  end
end
