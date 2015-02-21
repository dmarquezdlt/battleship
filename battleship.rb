

class Ship
  attr_accessor :type, :sunk, :position
  @@ship_data = {
    :Carrier => {:position => ["A1","A2","A3","A4","A5"]},
    :Battleship => {:position => ["B3","C3","D3","E3"]},
    :Submarine => {:position => ["D5","D6","D7"]},
    :Destroyer => {:position => ["E0","E1","E2"]},
    :Patrol => {:position => ["J8","J9"]}
  }

  def initialize(type)
    @type = type.to_sym
    @sunk = false
    @position = @@ship_data[type.to_sym][:position]
  end
end

class Board
  attr_accessor :contents, :hit_cells, :fleet

  def initialize(contents, fleet)
    @contents = contents
    @hit_cells = []
    @fleet = fleet
    self.put_ship_to_cell
  end

  def put_ship_to_cell
    @fleet.each do |ship|
      ship.position.each {|ship_part| @contents.select{|cell| cell.coordinates == ship_part }.first.type="ship" }
    end
  end

  def hit(user_input)
    return unless user_input =~ /^.{1}\d{1}$/
    return if user_input[1..-1].to_i > 9
    return if user_input[0] > "J"
    p current_cell = @contents.select { |cell| cell.coordinates ==
      user_input}.first
      current_cell.hit = true
      @hit_cells << current_cell
      @fleet.each do |boat|
        unsunk_boat_cells  = boat.position - @hit_cells
        if unsunk_boat_cells.length == 0
          boat.sunk = true
          puts "You sunk the #{boat.type.to_s}!"
        end
      end
    end

  def all_ships_sunk?
    all_hit_coor, all_ship_coor = [], []
    @hit_cells.each{|cell| all_hit_coor <<  cell.coordinates   }
    @fleet.each{|ship|all_ship_coor += ship.position  }
    return false if (all_ship_coor - all_hit_coor).length > 0
    true
  end

  end

  class Cell
    attr_accessor :coordinates, :type, :hit

    def initialize(coordinates)
      @coordinates = coordinates
      @type = "water"
      @hit = false
    end

  end


cells =[]
("A".."J").each { |letter| (0..9).each { |num| cells <<
  Cell.new(letter+num.to_s)  } }


#build fleet
fleet = []
battle_ship = Ship.new("Battleship")
carrier = Ship.new("Carrier")
sumbarine = Ship.new("Submarine")
destroyer = Ship.new("Destroyer")
patrol = Ship.new("Patrol")
fleet = [battle_ship, carrier, sumbarine, destroyer, patrol]

board=Board.new(cells, fleet)

cells =[]
("A".."J").each { |letter| (0..9).each { |num| cells << Cell.new(letter+num.to_s)  } }

battle_ship = Ship.new("Battleship")
carrier = Ship.new("Carrier")
sumbarine = Ship.new("Submarine")
destroyer = Ship.new("Destroyer")
patrol = Ship.new("Patrol")
fleet = [battle_ship, carrier, sumbarine, destroyer, patrol]
board=Board.new(cells, fleet)
$this = ''
def print_board(board)
  puts "**** BATTLE SHIP ****"
  printed_board = []
  board.contents.each do |cell|
    case cell.hit
    when true
      if cell.type=="water"
        printed_board << "O"
        $this = "You missed, idiot"
      else
        printed_board << "X"
        $this = "Pewn Pewn Pewn. Direct hit."
      end
    when false
      printed_board << "w"
    end
  end
  puts "  " + (0..9).to_a.join(" ")
  counter = "A"
  printed_board.each_slice(10) do |row|
    puts counter.to_s + " " + row.join(" ")
    counter = counter.next
  end
end

def clear_screen!
  print "\e[2J"
end

def move_to_home!
  print "\e[H"
end

user_input = ""

loop do
  clear_screen!
  move_to_home!
  # puts ""
  print_board(board)
  if board.all_ships_sunk?
    puts "ALL SHIPS HAVE BEEN SUNK "
    `say "whats my motha fucken name"`
    break
  end
  break if user_input == "EXIT"
  system(`say "#{$this}"`)
  puts "Enter a coordinate: (enter exit to quit)"
  user_input = gets.chomp.upcase
  board.hit(user_input)
  board.put_ship_to_cell
end







