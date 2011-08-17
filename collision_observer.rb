class CollisionObserver
  
  def notify(player1, player2)
    
  end
  
  def found_collision?(player1, player2)
    player1_space = Range.new(player1.min_x, player1.max_x)
    player1_space.include?(player2.min_x) || player1_space.include?(player2.max_x)
  end
  
  def deal_damage(player1, player2)
    return unless found_collision?(player1, player2)
    if player1.attacking?
      player2.inflict_damage(player1.attack)
    elsif player2.attacking?
      player1.inflict_damage(player2.attack)
    end
  end
  
end