class Player

  attr_reader :x, :y, :z, :health

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

    @x = @player_id == 1 ? 200 : 440
    @y = window.ground
    @z = 1

    @health = 100
  end

  def draw
    sprite.draw(x, y, z)
  end

  def move
    if animating?
      continue_animation
    else
      crouch or
      move_left or
      move_right or
      punch
    end
  end

  def x
    x_offset = animating? ? current_animation.x_offset : 0
    @x + x_offset
  end

  def min_x
    x
  end

  def max_x
    x + sprite.width
  end

  def width
    sprite.width
  end

  def height
    sprite.height
  end

  def punching?
    current_animation.is_a?(Punch)
  end

  def attacking?
    current_animation.is_a?(Attack)
  end

  def moving?
    current_animation.is_a?(Walk)
  end

  def push_back(x)
    # trying to walk but something is pushing back
    # only works for left facing player
    @x = x
    @x -= width if player1?
  end

  def attack
    current_animation
  end

  def inflict_damage(attack)
    if @last_attack === attack
      # don't take damage from same attack twice
      return false
    else
      @health -= attack.damage
      @last_attack = attack
    end
  end

  private ####################################################################

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
    return unless left_button?
    start_animation(Walk.new)
    @x -= 1
  end

  def move_right
    return unless right_button?
    start_animation(Walk.new)
    @x += 1
  end

  def sprite
    return @crouching if @crouched
    return @punching if punching?
    @standing
  end

  def punch
    return unless punch_button?
    options = player1? ? { } : { x_offset: -22 }
    start_animation Punch.new(options)
  end

  def current_animation
    @current_animation
  end

  def start_animation(animation)
    @current_animation ||= animation
  end

  def animating?
    !!@current_animation
  end

  def continue_animation
    @current_animation.tick
    @current_animation = nil if @current_animation.finished?
  end

  def left_button?
    key = player1? ? Gosu::KbA : Gosu::KbLeft
    @window.button_down?(key)
  end

  def right_button?
    key = player1? ? Gosu::KbD : Gosu::KbRight
    @window.button_down?(key)
  end

  def down_button?
    key = player1? ? Gosu::KbS : Gosu::KbDown
    @window.button_down?(key)
  end

  def punch_button?
    key = player1? ? Gosu::KbF : Gosu::KbM
    @window.button_down?(key)
  end
end

class Animation
  def self.animation_time(time = nil)
    @animation_time ||= time
  end

  def self.damage(hit_points = nil)
    @damage ||= hit_points
  end

  def initialize(options = {})
    @animation_time = self.class.animation_time
    @options = options
  end

  def x_offset
    @options[:x_offset].to_i
  end

  def tick
    @animation_time -= 1
  end

  def finished?
    @animation_time == 0
  end

  def damage
    self.class.damage
  end
end

class Walk < Animation
  animation_time 1
end

class Attack < Animation; end
class Punch < Attack
  animation_time 20
  damage 10
end