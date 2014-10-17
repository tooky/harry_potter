class Checkout
  def scan book
    books << book
  end

  def total
    set_totals.inject(&:+)
  end

  def sets
    sets = []
    books.each do |book|
      if sets.all? { |s| s.include?( book ) }
        sets << [book]
      else
        sets.reject { |s| s.include?( book ) }.first << book
      end
    end
    sets
  end

  def set_discounts
    sets.map { |set|
      case set.size
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
    }
  end

  def set_sub_totals
    sets.map { |set|
      set.map(&:price).inject(&:+)
    }
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
