class CollisionObserver
  
  def notify(player1, player2)
    
  end
  
  def found_collision?(player1, player2)
    player1_space = Range.new(player1.min_x, player1.max_x)
    player1_space.include?(player2.min_x) || player1_space.include?(player2.max_x)
  end
  
end