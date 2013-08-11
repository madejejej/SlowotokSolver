class Object
  def deep_copy( object )
    Marshal.load( Marshal.dump( object ) )
  end
end

class SlowotokSolver
  BOARD_SIZE = 4 
  
  def initialize
    @solution = []
  end

  def read_from_stdin
    @board = []
    BOARD_SIZE.times {   @board << gets.chomp.downcase.split('') }
    self
  end
 
  def solve
    word_file = File.open("words.txt")
    words = []
    word_file.each_line { |l| words << l.chomp }
    words.reject! { |x| x =~ /\s/ }.sort!
    (0..BOARD_SIZE-1).to_a.product((0..BOARD_SIZE-1).to_a).each do |point|
      _solve words, point[0], point[1]
    end
    @solution.sort!{ |x,y| y[0].length <=> x[0].length }
    self
  end

  def print_solution
    @solution.each do |sol|
      puts sol[0]
      print_tour sol[1]
    end
  end

  private 

  def print_tour tour
    board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) { "X" } }
    tour.each_with_index do |point, i|
      board[point[0]][point[1]] = i+1
    end   
  
    board.each do |row|
      row.each { |val| printf "%-3s", val }
      printf "\n"
    end
  end

  def _solve words, x, y, visited = nil, parents = nil, word = "", tour = []
    visited ||= Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) {false} }
    parent ||= Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) {[-1, -1]} }
    visited[x][y] = true
    word << @board[x][y]
    tour << [x,y]
    shot = words.bsearch { |w| w >= word }
    shot2 = words.bsearch { |w| w <= word }
    if (shot == word || shot2 == word) && word.length > 2 
      already_found = false
      @solution.each do |x| 
        already_found = true if x.include? word
      end
      @solution << [word, tour] unless already_found
    elsif (shot.nil? || shot[word].nil?) && (shot2.nil? || shot2[word].nil?)
      return
    end
  
    [-1, 0, 1].product([-1, 0, 1]).each do |move|
      nextx, nexty = x + move[0], y + move[1]
      unless nextx < 0 || nextx >= BOARD_SIZE || nexty < 0 || nexty >= BOARD_SIZE 
      end
      next if nextx < 0 || nextx >= BOARD_SIZE || nexty < 0 || nexty >= BOARD_SIZE || visited[nextx][nexty]
      visited1 = deep_copy(visited)
      parent1 = deep_copy(parent) 
      tour1 = deep_copy(tour)
      parent1[nextx][nexty] = [x,y]
      _solve words, nextx, nexty, visited1, parent1, String.new(word), tour1  
    end
  end
end

solver = SlowotokSolver.new

solver.read_from_stdin.solve.print_solution
