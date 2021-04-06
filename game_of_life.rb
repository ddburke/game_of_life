require 'curses'
require_relative './world.rb'

include Curses

class GameOfLife
  ROWS = 40
  COLUMNS = 120
  ALIVE_CELL_CHARACTER = 'Ω'
  DEAD_CELL_CHARACTER = ' '
  REFRESH_TIME = 0.4

  def initialize
    init_screen
    start_color
    crmode
    noecho
    curs_set(0)
    init_pair(COLOR_GREEN,COLOR_GREEN,COLOR_BLACK)
    timeout = 0
    stdscr.keypad(true)
    mousemask(BUTTON1_CLICKED|BUTTON2_CLICKED|BUTTON3_CLICKED|BUTTON4_CLICKED)
    @window =  Window.new(ROWS + 2,COLUMNS + 2, 0, 0)
    @window.attron(A_BOLD)
    @window.attron(color_pair(COLOR_GREEN)|A_BOLD)
    @window.keypad = true
    @window.nodelay = true
    @world = World.new(ROWS, COLUMNS)
    refresh
  end

  def update_window
    @window.box(?!, ?-, ?+)
    for row in (0...ROWS) do
      @window.setpos(row + 1, 1)
      for column in (0...COLUMNS) do
        @window << (@world.alive?(row, column) ? ALIVE_CELL_CHARACTER : DEAD_CELL_CHARACTER)
      end
    end
    @window.setpos(0, 54)
    @window.addstr(" Game of Life ")
    @window.setpos(ROWS + 1, 5)
    @window.addstr(" ESC: Quit, TAB: Run, DELETE: Clear ")
    @window.refresh
  end

  def start
    run = false
    loop do
      update_window
      if run
        @world.next_generation
        sleep(REFRESH_TIME)
      end
      case @window.getch
      when KEY_MOUSE
        run = false
        if m = getmouse
          if m.x > 0 && m.x < COLUMNS + 1 && m.y > 0 && m.y < ROWS + 1
            if @world.alive?(m.y - 1, m.x - 1)
              @world.make_dead(m.y - 1, m.x - 1)
            else
              @world.make_alive(m.y - 1, m.x - 1)
            end
          end
        end
      when 27 #escape
        @window.close
        close_screen
        break
      when 9 #tab
        run = true
      when 127 #delete
        run = false
        @world = World.new(ROWS, COLUMNS)
      end
    end
  end
end

GameOfLife.new.start
