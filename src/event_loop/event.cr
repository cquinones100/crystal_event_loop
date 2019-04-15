require "./loop"

class Event
  def initialize(
    @work : Proc(Loop, Nil),
    @event_loop : Loop,
    @times : Int32 = 0,
    @count : Int32 = 0
  )
  end

  def perform : Nil
    @work.call(@event_loop)

    @count += 1

    @event_loop.delete_event(self) if delete?

    nil
  end

  private def delete? : Bool
    return false if @times.zero?

    @count >= @times
  end
end

