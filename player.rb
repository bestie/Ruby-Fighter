class Player
  
  attr_accessor :x, :y, :z
  
  def initialize(window, player_id)
    @window = window
    @player_id = player_id
    
    rimage = Magick::Image.read('media/ryu.bmp').first
    rimage = rimage.flop unless player1?
    
    standing_segment = [40, 0, 38, 72]
    crouching_segment = [0, 121, 40, 48]
    punching_segment = [258, 188, 60, 72]
    # 320 x 439 
    
    unless player1?
      # standing_segment = (standing_segment[0] - 439 - standing_segment[3]), 0, 38, 72
      standing_segment[0] = (320 - 40 - 38)
      crouching_segment[0] = (320 - 0 - 40)
      punching_segment[0] = (320 - 258 - 60)
      
      # dims = rimage.rows, rimage.columns , 0, 0
      # standing_segment = standing_segment.zip(dims).map{ |a| a[1] - a[0] }
      # crouching_segment = crouching_segment.zip(dims).map{ |a| a[1] - a[0] }
    end
    
    @standing = Gosu::Image.new(@window, rimage, false, *standing_segment)
    @crouching = Gosu::Image.new(@window, rimage, false, *crouching_segment)
    @punching = Gosu::Image.new(@window, rimage, false, *punching_segment)
    
    @x = @player_id == 1 ? 100 : 540
    @y = window.ground
    @z = 1
    
    @animating = 0
  end
  
  def draw
    sprite.draw(@x, @y, @z)
  end
  
  def move
    
    # needs some sort of current animation method
    if @animating > 0
      @animating -= 1
      
      @throwing_punch = false if @animating == 0 # animation finished
      
      return @animating
    end
    
    crouch or
    move_left or
    move_right or
    punch
  end
  
  def min_x
    @x
  end
  
  def max_x
    @x + sprite.width
  end
  
  def width
    sprite.width
  end
  
  def height
    sprite.height
  end
  
  private
  
  def player1?
    @player_id == 1
  end
  
  def crouch
    if down_button?
      @y = @window.ground + 26
      @crouched = true
    else
      @y = @window.ground
      @crouched = false
    end
  end
  
  def move_left
    @x -= 1 if left_button?
  end
  
  def move_right
    @x += 1 if right_button?
  end
  
  def sprite
    return @crouching if @crouched
    return @punching if @throwing_punch
    @standing
  end
  
  def punch
    if punch_button?
      @throwing_punch = true 
      @animating = 20
    end
  end
  
  def left_button?
    key = player1? ? Gosu::KbLeft : Gosu::KbA
    @window.button_down?(key)
  end
  
  def right_button?
    key = player1? ? Gosu::KbRight : Gosu::KbD
    @window.button_down?(key)
  end
  
  def down_button?
    key = player1? ? Gosu::KbDown : Gosu::KbS
    @window.button_down?(key)
  end
  
  def punch_button?
    key = player1? ? Gosu::KbM : Gosu::KbF
    @window.button_down?(key)
  end
end
    