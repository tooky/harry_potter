require 'ostruct'
require 'potter'

describe "pricing sets of harry potter books" do
  let(:checkout) { Checkout.new }
  let(:book1) { OpenStruct.new name: 'book1', price: 8 }
  let(:book2) { OpenStruct.new name: 'book2', price: 8 }
  let(:book3) { OpenStruct.new name: 'book3', price: 8 }
  let(:book4) { OpenStruct.new name: 'book4', price: 8 }
  let(:book5) { OpenStruct.new name: 'book5', price: 8 }

  def scan(*books)
    books.each { |b| checkout.scan b }
  end

  it "provides no discount for a single book" do
    scan book1

    expect( checkout.total ).to eq 8
  end

  it "does not discount multiples of one book" do
    scan book1, book1, book1

    expect( checkout.total ).to eq 24
  end

  it "discounts a set of two books by 5%" do
    scan book1, book4

    expect( checkout.total ).to eq 16 * 0.95
  end

  it "discounts a set of three books by 10%" do
    scan book1, book2, book4

    expect( checkout.total ).to eq 24 * 0.90
  end

  it "discounts a set of four books by 20%" do
    scan book1, book2, book3, book4

    expect( checkout.total ).to eq 32 * 0.80
  end

  it "discount a set of five books by 25%" do
    scan book1, book2, book3, book4, book5

    expect( checkout.total ).to eq 40 * 0.75
  end

  it "does not discount books outside of the set" do
    scan book1, book1, book2

    expect( checkout.total ).to eq 8 + 16 * 0.95
  end

  it "handles finding the best discount" do
    scan book1, book1
    scan book2, book2
    scan book3, book3
    scan book4
    scan book5

    expect( checkout.total ).to eq( 32 * 0.8 + 32 * 0.8 )
  end
end
