require 'ostruct'

class Checkout
  def scan book
    books << book
  end

  def total
    books.map(&:price).inject(&:+)
  end

  private
  def books
    @books ||= []
  end
end

describe "pricing sets of harry potter books" do
  it "provides no discount for a single book" do
    book1 = OpenStruct.new name: 'book1', price: 8
    checkout = Checkout.new
    checkout.scan book1

    expect( checkout.total ).to eq 8
  end
end
