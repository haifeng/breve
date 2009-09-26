class FullName
  attr_reader :firstname, :lastname
  
  def initialize(firstname, lastname)
    @firstname = firstname
    @lastname  = lastname
  end
  
  def to_s
    "#@firstname #@lastname".titleize
  end
end