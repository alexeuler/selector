module Test
  def a
    puts self
  end
end

class B
  extend Test
end

B.a