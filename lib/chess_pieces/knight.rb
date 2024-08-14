require_relative 'chesspiece_main.rb'

class Knight < Chesspiece
  def initialize(type)
      @type = type
  end

  def knight_move_check(chesspiece_location,chesspiece_distination)
      # create duplicate value cus it's not stored in the same ref in memoery
      value = ""
      
      value = vertical_moves(chesspiece_location,chesspiece_distination)
      return value if value != false
      value = horizontal_moves(chesspiece_location,chesspiece_distination)
      return value if value != false
      
      return false

  end

  def vertical_moves(chesspiece_location,chesspiece_distination)
      location = chesspiece_location.dup
      distination = chesspiece_distination.dup

          if distination[0] > location[0]
              #moving up
              location[0] += 2
              return false if location[0] > distination[0] 
              #return false if chesspiece_location[1] <= chesspiece_distination[1]
              if distination[1] > location[1]
                  location[1] += 1
                  return location if distination == location
              elsif distination[1] < location[1]
                  location[1] -= 1
                  return location if distination == location
              end
              return false 
          elsif distination[0] < location[0]
              #moving down
              location[0] -= 2
              if distination[1] > location[1]
                  location[1] += 1
                  return location if distination == location
              elsif distination[1] < location[1]
                  location[1] -= 1
                  return location if distination == location
              end
              return false
      end
      return false
  end

  def horizontal_moves(chesspiece_location,chesspiece_distination)
      location = chesspiece_location.dup
      distination = chesspiece_distination.dup

          if distination[1] > location[1]
              #moving right
              location[1] += 2
              #return false if location[1] > distination[1]
              if distination[0] < location[0]
                  location[0] -= 1
                  return location if distination == location
              elsif distination[0] > location[0]
                  location[0] += 1
                  return location if distination == location
              end
              return false
          elsif distination[1] < location[1]
              #moving left
              location[1] -= 2
              #return false if location[1] < distination[1]
              if distination[0] < location[0]
                  location[0] -= 1
                  return location if distination == location
              elsif distination[0] > location[0]
                  location[0] += 1
                  return location if distination == location
              end
              return false
          end
      return false
  end

end