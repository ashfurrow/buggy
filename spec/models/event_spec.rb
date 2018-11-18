require 'slack-buggybot/models/event'

describe SlackBuggybot::Event do
  describe 'instances methods' do
  end

  describe 'class methods' do
    describe 'with existing events in the db' do
      before do 
        @events = Array.new(10).each_with_index.map do |_, index|
          event = SlackBuggybot::Event.new(start: Time.now.utc, owner: OWNER_ID, channel_id: CHANNEL_ID)
          event.update(end: Time.now.utc) unless index == 9
          event
        end
      end

      it 'has one #open event' do
        expect(SlackBuggybot::Event.open.count) == 1
      end

      it 'returns the user current event' do
        @events.last.update(users: [USER_ID])
        expect(SlackBuggybot::Event.user_current_event(user_id: USER_ID).id) == @events.last.id
      end

      describe '#find_from_match' do
        it 'returns nil when there are no open events' do
          
        end
        it 'returns the first event when there are only one events in progress' do
        end
        it 'returns nil when there are multiple open events and match was not specified' do
        end
        it 'returns the event when there are multiple open events and match was specified' do
        end
      end
    end
  end
end
