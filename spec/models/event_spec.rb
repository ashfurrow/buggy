# frozen_string_literal: true

require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'
require 'digest'

# Hey. Complicated tests, eh? Well, I wanted to explore what Rspec tests _could_
# be (and not necessarily _should_ be).

describe SlackBuggybot::Event do
  describe 'instances methods' do
    before do
      @client = double("client")
      @owner = double("owner")
      allow(@owner).to receive(:real_name).and_return("dB")
      allow(@owner).to receive(:id).and_return(OWNER_ID)
      @players = %w(ash jon dan luc eve).map do |name|
        user = double(name)
        allow(user).to receive(:real_name).and_return(name.capitalize)
        allow(user).to receive(:id).and_return(Digest::MD5.hexdigest(name).upcase[0..7])
        user
      end
      @ash, @jon, @dan, @luc, @eve = @players
      @users = @players + [@owner]
      allow(@client).to receive(:users).and_return(@users.reduce({}) do |m, u|
        m[u.id] = u
        m
      end)
      @event = SlackBuggybot::Event.new(start: Time.now.utc, owner: OWNER_ID, channel_id: CHANNEL_ID, users: @players.map(&:id))
    end

    it '#name_from_client' do
      expect(@event.name_from_client(@client)).to eq("dB's bug bash")
    end

    context 'with activity' do
      before do
        @players.each do |p|
          allow(SlackBuggybot::Bug).to receive(:user_finished_bugs).with(hash_including({user_id: p.id})) do
            case p
            when @ash
              Array.new(9) # I get to win in the unit tests, sorry.
            when @jon
              Array.new(5) # Was going to make everyone 666 but it's easier if they're all unique
            when @dan
              Array.new(6)
            when @luc
              Array.new(7)
            when @eve
              Array.new(8)
            end
          end
        end
      end

      it '#winning_result_from_client' do
        expect(@event.winning_result_from_client(@client)).to eq([@ash, 9])
      end

      it '#leaderboard_from_client' do
        expect(@event.leaderboard_from_client(@client)).to eq(<<~LEADERBOARD.strip
          Ash: 9 points
          Eve: 8 points
          Luc: 7 points
          Dan: 6 points
          Jon: 5 points
          LEADERBOARD
          )
      end
    end
  end

  describe 'class methods' do
    context 'with existing events in the db' do
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
