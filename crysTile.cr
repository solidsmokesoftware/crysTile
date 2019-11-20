

class TileMap
  property x_size : Int32
  property y_size : Int32
  property grid : Array(Array(Int32))

  def initialize(x : Int32, y : Int32)
    @x_size = x
    @y_size = y
    @grid = Array(Array(Int32)).new
    x.times do
      @grid << Array(Int32).new
    end
  end

  def add(x : Int32, value : Int32)
    @grid[x] << value
  end

  def set(x : Int32, y : Int32, value : Int32)
    @grid[x][y] = value
  end

  def get(x : Int32, y : Int32) : Int32
    @grid[x][y]
  end

  def print
    @grid.each do |i|
      puts "#{i}\n"
    end
  end

end#class


class Builder
  property seed
  property r

  def initialize(seed : Int64)
    @seed = seed
    @r = Random.new seed
  end

  def build(x : Int32, y : Int32) : TileMap
    tilemap = TileMap.new x, y
    x.times do |ix|
      y.times do |iy|
        build ix, iy, tilemap
      end
    end
    finish tilemap
    tilemap
  end
  
  def build(x : Int32, y : Int32, tilemap : TileMap)
    tilemap.add x, 0
  end
  
  def finish(tilemap : TileMap)
  end

end#class


class SimpleRoom < Builder
  def build(x : Int32, y : Int32, tilemap : TileMap)
    option = 0
    if x == 0 || x == tilemap.x_size - 1
      option = 1
    elsif y == 0 || y == tilemap.y_size - 1
      option = 1
    end

    tilemap.add x, option
  end
  
  def finish(tilemap : TileMap)
    choice = [1, 2, 2, 3, 3, 3, 4]
    exits = choice[@r.rand(choice.size)]

    unused_walls = ["up", "down", "left", "right"]
    walls = Array(String).new
    exits.times do |exit|
      c = @r.rand unused_walls.size
      walls << unused_walls[c]
      unused_walls.delete_at c
    end

    x = 0
    y = 0
    walls.each do |wall|
      if wall == "up"
        x = @r.rand(tilemap.x_size - 2) + 1
        y = tilemap.y_size - 1
        
      elsif wall == "down"
        x = @r.rand(tilemap.x_size - 2) + 1
        y = 0 

      elsif wall == "right"
        x = tilemap.x_size - 1
        y = @r.rand(tilemap.y_size - 2) + 1

      elsif wall == "left"
        x = 0
        y = @r.rand(tilemap.y_size - 2) + 1
      end
      
      tilemap.set x, y, 2
    end
  end

end#class


b = SimpleRoom.new 100

4.times do |i|
  tilemap = b.build i + 4, i + 4
  tilemap.print
end