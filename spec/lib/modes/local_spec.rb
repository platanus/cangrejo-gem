require "cangrejo/modes/local"
require "sys/proctable"

describe Cangrejo::Modes::Local do

  let!(:srv) { described_class.new TEST_APP_PATH }
  after(:example) { srv.release }

  describe "setup" do

    it "should start the crawler at given path" do
      expect { srv.setup }.to change {
        Sys::ProcTable.ps.select { |p| p.cmdline && p.cmdline.include?('crabfarm') }.count
      }.by(1)
    end

    it "should return a rest client instance connected to the crawler" do
      session = srv.setup
      expect(session).to be_a RestClient::JsonResource
      expect(session.put(name: :repeater).name).to eq 'repeater'
    end

  end

  describe "release" do

    it "should ensure that crawler is killed" do
      srv.setup

      expect { srv.release }.to change {
        Sys::ProcTable.ps.select { |p| p.cmdline && p.cmdline.include?('crabfarm') }.count
      }.by(-1)
    end

  end

end