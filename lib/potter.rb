class Checkout
  def scan book
    best_set_for(book) << book
  end

  def total
    sets.map(&:total).inject(&:+)
  end

  private

  def best_set_for(book)
    best_exisiting_set_for(book) || add_new_set
  end

  def best_exisiting_set_for(book)
    sets.select { |s| s.requires?( book ) }
        .min { |a,b| a.delta_with(book) <=> b.delta_with(book) }
  end

  def sets
    @sets ||= []
  end

  def add_new_set
    Set.new.tap { |s| sets << s }
  end

  class Set
    DISCOUNTS = {
      2 => 5,
      3 => 10,
      4 => 20,
      5 => 25,
    }

    def initialize *books
      @books = books
    end

    def requires?(book)
      !@books.include?(book)
    end

    def total
      calculate_discount(sub_total, discount)
    end

    def delta_with(book)
      new_sub_total = sub_total + book.price
      calculate_discount(new_sub_total, next_discount) - total
    end

    def << book
      @books << book
      self
    end

    private

    def discount(num_books = size)
      DISCOUNTS.fetch(num_books) { 0 }
    end

    def sub_total
      @books.map(&:price).inject(&:+)
    end

    def calculate_discount(price, discount)
      price * (100 - discount) / 100.0
    end

    def next_discount
      discount(size + 1)
    end

    def each(&block)
      @books.each(&block)
    end

    def size
      @books.size
    end
  end
end
