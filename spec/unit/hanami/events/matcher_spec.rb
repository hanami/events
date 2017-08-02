RSpec.describe Hanami::Events::Matcher do
  let(:matcher) { described_class.new(pattern) }

  context 'when pattern match only one event' do
    let(:pattern) { 'user.created' }

    it { expect(matcher.match?('user.created')).to be true }
    it { expect(matcher.match?('user.updated')).to be false }
    it { expect(matcher.match?('post.created')).to be false }
  end

  context 'when pattern match range of events' do
    let(:pattern) { 'user.*' }

    it { expect(matcher.match?('user.created')).to be true }
    it { expect(matcher.match?('user.updated')).to be true }
    it { expect(matcher.match?('post.created')).to be false }

    context 'and range on beginig' do
      let(:pattern) { '*.created' }

      it { expect(matcher.match?('user.created')).to be true }
      it { expect(matcher.match?('user.updated')).to be false }
      it { expect(matcher.match?('post.created')).to be true }
    end

    context 'and consist of 3 parts' do
      let(:pattern) { 'admin.*.created' }

      it { expect(matcher.match?('admin.user.created')).to be true }
      it { expect(matcher.match?('admin.user.updated')).to be false }
      it { expect(matcher.match?('admin.post.created')).to be true }
    end

    context 'and consist of 3 parts' do
      let(:pattern) { 'admin.user.*' }

      it { expect(matcher.match?('admin.user.created')).to be true }
      it { expect(matcher.match?('admin.user.updated')).to be true }
      it { expect(matcher.match?('admin.post.created')).to be false }
    end
  end

  context 'when pattern match all' do
    let(:pattern) { '*' }

    it { expect(matcher.match?('user.created')).to be true }
    it { expect(matcher.match?('user.updated')).to be true }
    it { expect(matcher.match?('post.created')).to be true }

    context 'and consist of 3 parts' do
      let(:pattern) { '*' }

      it { expect(matcher.match?('admin.user.created')).to be true }
      it { expect(matcher.match?('admin.user.updated')).to be true }
      it { expect(matcher.match?('admin.post.created')).to be true }
    end
  end

  context 'when pattern contains invalid chars' do
    let(:pattern) { 'user.cre*ated' }

    it { expect(matcher.match?('user.cre*ated')).to be true }
    it { expect(matcher.match?('user.created')).to be false }
    it { expect(matcher.match?('user.updated')).to be false }
    it { expect(matcher.match?('post.created')).to be false }
  end
end
