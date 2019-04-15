require "./event"

class Loop
  getter count, state

  def initialize(
    @state : Hash = {} of String => Int32 | String,
    @tick_speed : Int32 | Float64 = 1,
    @alive : Bool = false,
    @count : Int32 = 0,
    @tracked_events : Array(Event) = [] of Event,
    @print_tick : Bool = false
  )
  end

  def start(@print_tick : Bool = false) : Nil
    @alive = true

    spawn do
      while alive?
        execute_tick
      end
    end
  end

  def kill : Nil
    @alive = false
  end

  def execute_tick : Nil
    puts "tick #{@count}" if print_tick?

    refresh

    @count += 1

    sleep @tick_speed
  end

  def set_state(state : Hash) : Nil
    @state = state
  end

  def kill_after(kill_after_count : Int32) : Nil
    work = -> (event_loop : Loop) do
      if event_loop.count == kill_after_count
        kill

        nil
      end
    end

    add_work work

    nil
  end

  def add_work(work : Proc(Loop, Nil), times : Int32 = 0) : Nil
    @tracked_events << Event.new(work: work, event_loop: self, times: times)

    nil
  end

  def delete_event(event : Event) : Nil
    @tracked_events.delete(event)

    nil
  end

  def sleep_ticks(ticks : Int32 | Float64) : Nil
    sleep @tick_speed * ticks
  end

  def keep_running : Nil
    loop do
      sleep 1
    end
  end

  private def alive? : Bool
    @alive
  end

  private def refresh : Nil
    @tracked_events.each { |event| event.perform }
  end

  private def print_tick? : Bool
    @print_tick
  end
end

