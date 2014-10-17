class Checkout
  def initialize
    @sets = []
  end

  def scan book
    books << book
    if @sets.all? { |s| s.include?( book ) }
      @sets << Set.new(book)
    else
      @sets.reject { |s| s.include?( book ) }.first << book
    end
  end

  def total
    sets.map(&:total).inject(&:+)
  end

  class Set
    include Enumerable

    def initialize *books
      @books = books
    end

    def discount
      case size
      when 2
        5
      when 3
        10
      when 4
        20
      when 5
        25
      else
        0
      end
    end

    def sub_total
      map(&:price).inject(&:+)
    end

    def total
      sub_total * (100 - discount) / 100.0
    end

    def << book
      @books << book
      self
    end

    def each(&block)
      @books.each(&block)
    end

    def size
      @books.size
    end
  end

  def sets
    @sets
  end

  def old_sets
    sets = []
    books.each do |book|
      if sets.all? { |s| s.include?( book ) }
        sets << Set.new(book)
      else
        sets.reject { |s| s.include?( book ) }.first << book
      end
    end
    sets
  end

  private
  def books
    @books ||= []
  end

end
