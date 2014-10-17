class Checkout
  def scan book
    books << book
  end

  def total
    set_totals.inject(&:+)
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

  def set_discounts
    sets.map { |set| set.discount }
  end

  def set_sub_totals
    sets.map { |set| set.sub_total }
  end

  def set_totals
    set_sub_totals.zip(set_discounts).map { |total, discount|
      total * (100 - discount) / 100.0
    }
  end

  private
  def books
    @books ||= []
  end

end
