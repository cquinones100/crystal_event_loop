require "../spec_helper"
require "../../src/event_loop/loop"
require "../../src/event_loop/event"
require "mocks/spec"

TICK_SPEED = 0.001

def prepare_loop(
  work,
  times : Int32 = 0,
  sleep_ticks : Int32 | Float64 = TICK_SPEED,
  kill : Bool = false
) 
  Loop.new(tick_speed: TICK_SPEED).tap do |event_loop|
    event_loop.add_work work, times: times

    event_loop.start

    event_loop.sleep_ticks sleep_ticks

    event_loop.kill if kill
  end
end

describe Loop do
  num = 0
  work = -> (event_loop : Loop) { num += 1; nil }

  describe "#add_work" do

    context "when work is to be completed once" do
      it do
        num = 0

        prepare_loop work, times: 1, kill: true

        num.should eq 1
      end
    end
  end

  context "when work is to be completed indefinitely" do
    number_of_ticks = 5

    it do
      num = 0

      prepare_loop work, sleep_ticks: number_of_ticks, kill: true

      num.should eq number_of_ticks
    end
  end

  describe "#kill" do
    number_of_ticks = 1

    it do
      num = 0

      event_loop = prepare_loop work, sleep_ticks: number_of_ticks

      event_loop.kill

      num.should eq number_of_ticks
    end
  end

  # describe "#kill_after" do

  # end
end
