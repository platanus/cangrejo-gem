describe Cangrejo do

  before {
    Cangrejo.config[:crawlers][nil] = {
      remote: 'fake/remote'
    }

    Cangrejo.config[:crawlers][:other] = {
      remote: 'fake/other'
    }
  }

  describe 'connect' do

    it "should call Session.connect with the default crawler setup if no crawler is given" do
      expect(Cangrejo::Session).to receive(:connect).with({ remote: 'fake/remote' })

      Cangrejo.connect { |s| }
    end

    it "should properly pass the given block to Session.connect" do
      allow(Cangrejo::Session).to receive(:connect).and_yield(:a_session)

      session_1 = nil, session_2 = nil

      Cangrejo.connect { |s| session_1 = s }
      Cangrejo.connect(:other) { |s| session_2 = s }

      expect(session_1).to eq(:a_session)
      expect(session_2).to eq(:a_session)
    end

  end

end
