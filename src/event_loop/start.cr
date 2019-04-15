require "./loop"

event_loop = Loop.new tick_speed: 0.25

event_loop.start print_tick: true

event_loop.add_work ->(event_loop : Loop) { puts event_loop.state }

event_loop.sleep_ticks 2

event_loop.add_work ->(event_loop : Loop) { puts "hi!" }, times: 1

event_loop.keep_running
