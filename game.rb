require 'rubygems'
require 'gosu'
require 'rmagick'
require 'player'
require 'collision_observer'


class GameWindow < Gosu::Window
  
  TITLE = 'Nerd Fighter'
  TITLE_FONT = 'Comic Sans MS'
  
  def initialize
    super 640, 480, false
    self.caption = TITLE
    
    @title = Gosu::Image.from_text(self, TITLE, TITLE_FONT, 32)
    @collision_notice = Gosu::Image.from_text(self, 'Boom', TITLE_FONT, 32)
    
    @player1 = Player.new(self, 1)
    @player2 = Player.new(self, 2)
    
    # @background_image = Gosu::Image.new(self, rimage, true)
  end
  
  def ground
    @ground ||= 200
  end

  def update
    # game_objects.collect(&:update)
    @player1.move
    @player2.move
  end

  def draw
    draw_centered(@title, 20, 0)
    draw_centered(@collision_notice, 100, 0) if collision_watcher.found_collision?(@player1, @player2)
    
    # game_objects.collect(&:draw)
    @player1.draw
    @player2.draw
  end
  
  def button_down(id)
    close if id == Gosu::KbEscape
  end
  
  def collision_watcher
    @collision_watcher ||= CollisionObserver.new
  end
  
  private
  
  def draw_centered(image, y = 0, z = 0)
    offset = (self.width - image.width) / 2
    image.draw(offset, y, z)
  end
end

window = GameWindow.new
window.show