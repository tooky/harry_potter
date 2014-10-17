class Checkout
  def scan book
    sets.add_book book
  end

  def total
    sets.map(&:total).inject(&:+)
  end

  class SetCollection
    include Enumerable

    def add_book(book)
      best_set_for(book) << book
    end

    def best_set_for(book)
      sets.detect { |s| !s.include?( book ) } || Set.new.tap { |s| sets << s }
    end

    def each(&block)
      sets.each(&block)
    end

    private
    def sets
      @sets ||= []
    end
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
    @sets ||= SetCollection.new
  end

end
