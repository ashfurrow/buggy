# frozen_string_literal: true

require 'slack-buggybot/models/event'

describe SlackBuggybot::Event do
  describe 'instances methods' do
  end

  describe 'class methods' do
    describe 'with existing events in the db' do
      before(:each) do
        @events = Array.new(10).map do
          SlackBuggybot::Event.new(start: Time.now.utc, owner: OWNER_ID, channel_id: CHANNEL_ID)
        end
        @events[0...-1].each { |e| e.update(end: Time.now.utc) }
        @events.map(&:save)
      end

      it 'has one #open event' do
        expect(SlackBuggybot::Event.open.count).to eq(1)
        expect(SlackBuggybot::Event.open.last).not_to be_nil

        expect(SlackBuggybot::Event.find_from_match(expression: '2').id) == @events.last.id
      end

      it 'returns the user current event' do
        @events.last.update(users: [USER_ID])
        expect(SlackBuggybot::Event.user_current_event(user_id: USER_ID).id) == @events.last.id
      end

      describe '#find_from_match' do
        it 'returns nil when there are no open events' do
          @events.each { |e| e.update(end: Time.now.utc) }
          expect(SlackBuggybot::Event.find_from_match({})).to be_nil
        end
        it 'returns the first event when there are only one events in progress' do
          expect(SlackBuggybot::Event.find_from_match({}).id) == @events.last.id
        end
        it 'returns nil when there are multiple open events and match was not specified' do
          @events[0...-4].each { |e| e.update(end: nil) }
          expect(SlackBuggybot::Event.find_from_match({})).to be_nil
        end
        it 'returns the event when there are multiple open events and match was specified' do
          @events[0...-4].each { |e| e.update(end: nil) }
          expect(SlackBuggybot::Event.find_from_match(expression: @events.last.id.to_s).id) == @events.last.id
        end
      end
    end
  end
end
