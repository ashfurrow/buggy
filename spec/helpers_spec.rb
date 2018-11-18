# frozen_string_literal: true

require 'slack-buggybot/helpers'

describe 'helpers' do
  describe '#random_fun_emoji' do
    it 'begins and ends with a colon' do
      emoji = random_fun_emoji
      expect(emoji.start_with?(':')).to be_truthy
      expect(emoji.end_with?(':')).to be_truthy
    end
  end

  describe '#random_emojis' do
    it 'contains at least 6 colons' do
      emojis = random_emojis
      expect(emojis.count(':')).to be >= 6
    end
  end
end
