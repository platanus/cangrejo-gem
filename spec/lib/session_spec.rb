describe Cangrejo::Session do

  let(:fake_rest) {
    spy('rest_client', {
      :put => nil,
      :doc => { 'foo' => 'bar' }
    })
  }

  let(:fake_mode) {
    spy('session_mode', {
      :setup => fake_rest,
      :release => nil
    })
  }

  let(:session) { Cangrejo::Session.new mode: fake_mode }

  describe 'start' do

    it "should call the mode's setup method" do
      session.start
      expect(fake_mode).to have_received(:setup) { fake_rest }
    end

    it "should should fail if called twice" do
      session.start
      expect { session.start }.to raise_error Cangrejo::ConfigurationError
    end

  end

  describe 'crawl' do

    it "should should fail if session has not been started" do
      expect { session.crawl :my_state }.to raise_error Cangrejo::ConfigurationError
    end

    context "when session has been started" do

      before { session.start }

      it "should call the mode's provided restclient put method with the specified params and a timestamp" do
        ts = DateTime.now.strftime('%Q')
        session.crawl :my_state, foo: 'bar'
        expect(fake_rest).to have_received(:put).with({ name: :my_state, params: { foo: 'bar', '_ts' => ts }, wait: Cangrejo::Session::WAIT_STEP })
      end

      it "should make the received document available in the doc property" do
        expect(session.doc).to be_nil
        session.crawl :my_state, foo: 'bar'
        expect(session.doc.foo).to eq('bar')
      end

    end

  end

  describe 'release' do

    it "should call the mode's release method" do
      session.release
      expect(fake_mode).to have_received(:release)
    end

  end

  describe 'connect' do

    it "should yield a started session" do
      Cangrejo::Session.connect mode: fake_mode do |session|
        expect(fake_mode).to have_received(:setup)\
      end
    end

    it "should release session after blocks exits without errors" do
      Cangrejo::Session.connect mode: fake_mode do |session|
      end
      expect(fake_mode).to have_received(:release)
    end

    it "should relase session after blocks exits with error" do
      Cangrejo::Session.connect mode: fake_mode do |session|
        raise 'teapot'
      end rescue nil
      expect(fake_mode).to have_received(:release)
    end

  end

end
