$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'gosu'
require 'rmagick'
require 'player'
require 'collision_observer'

class GameWindow < Gosu::Window

  TITLE = 'Ruby Fighter'
  TITLE_FONT = 'Comic Sans MS'

  def initialize
    super 640, 480, false
    self.caption = TITLE

    @title = Gosu::Image.from_text(self, TITLE, TITLE_FONT, 32)
    @collision_notice = Gosu::Image.from_text(self, 'Boom', TITLE_FONT, 32)

    @player1 = Player.new(self, 1)
    @player2 = Player.new(self, 2)

    @collision_watcher = CollisionObserver.get_instance
    @collision_watcher.set_players(@player1, @player2)

    # @background_image = Gosu::Image.new(self, rimage, true)
  end

  def ground
    @ground ||= 200
  end

  def update
    # game_objects.collect(&:update)
    @player1.move
    @player2.move
    collision_watcher.deal_damage
  end

  def draw
    draw_centered(@title, 20, 0)
    draw_centered(@collision_notice, 100, 0) if collision_watcher.found_collision?

    Gosu::Image.from_text(self, @player1.health, TITLE_FONT, 32).draw(100,100,1)
    Gosu::Image.from_text(self, @player2.health, TITLE_FONT, 32).draw(640 - 100,100,1)

    # game_objects.collect(&:draw)

    # walking collision and pushing, doesn't quite work.
    if collision_watcher.found_collision?
      if @player1.moving? && @player2.moving?
        @player1.push_back(@player2.min_x)
        @player2.push_back(@player1.max_x)
      elsif @player1.moving? && !@player2.moving?
        @player2.push_back(@player1.max_x)
      elsif @player2.moving? && !@player1.moving?
        @player1.push_back(@player2.min_x)
      end
    end

    @player1.draw
    @player2.draw
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

  def collision_watcher
    @collision_watcher
  end

  private

  def draw_centered(image, y = 0, z = 0)
    offset = (self.width - image.width) / 2
    image.draw(offset, y, z)
  end
end

window = GameWindow.new
window.show
