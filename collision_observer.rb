class CollisionObserver

  def self.get_instance
    @instance ||= new
  end

  def set_players(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def found_collision?
    player1_space = Range.new(player1.min_x, player1.max_x)
    player1_space.include?(player2.min_x) || player1_space.include?(player2.max_x)
  end

  def deal_damage
    return unless found_collision?
    if player1.attacking?
      player2.inflict_damage(player1.attack)
    elsif player2.attacking?
      player1.inflict_damage(player2.attack)
    end
  end

  private

  attr_reader :player1, :player2

end