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
      set = sets.select { |s| !s.include?( book ) }.min { |a,b| a.delta_if(book.price) <=> b.delta_if(book.price) }
      set || add_new_set
    end

    def each(&block)
      sets.each(&block)
    end

    private
    def sets
      @sets ||= []
    end

    def add_new_set
      Set.new.tap { |s| sets << s }
    end
  end

  class Set
    include Enumerable

    def initialize *books
      @books = books
    end

    def discount(num_books = size)
      case num_books
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
      calculate_discount(sub_total, discount)
    end

    def calculate_discount(price, discount)
      price * (100 - discount) / 100.0
    end

    def next_discount
      discount(size + 1)
    end

    def delta_if(price)
      new_sub_total = sub_total + price
      calculate_discount(new_sub_total, next_discount) - total
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
