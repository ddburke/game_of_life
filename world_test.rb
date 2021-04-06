require_relative './world.rb'

world = World.new(40, 120)
puts world.alive?(0, 0)
world.make_alive(0, 1)
world.make_alive(1, 0)
world.make_alive(1, 1)
# world.make_dead(11, 19)
# puts world.alive?(9, 22)
#puts world.amount_of_neighbours(0, 0)
world.next_generation
#puts world.grid.inspect
