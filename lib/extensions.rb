class String
  def truncate(maxlen = -1)
    maxlen < 0 ? self : self.gsub(/^(.{#{maxlen}}[\w.]*)(.*)/) {$2.empty? ? $1 : $1 + '...'}
  end
end