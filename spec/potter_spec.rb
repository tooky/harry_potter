require 'ostruct'
require 'potter'

describe "pricing sets of harry potter books" do
  let(:checkout) { Checkout.new }
  let(:book1) { OpenStruct.new name: 'book1', price: 8 }
  let(:book2) { OpenStruct.new name: 'book2', price: 8 }
  let(:book3) { OpenStruct.new name: 'book3', price: 8 }
  let(:book4) { OpenStruct.new name: 'book4', price: 8 }
  let(:book5) { OpenStruct.new name: 'book5', price: 8 }

  it "provides no discount for a single book" do
    checkout.scan book1

    expect( checkout.total ).to eq 8
  end

  it "does not discount multiples of one book" do
    checkout.scan book1
    checkout.scan book1
    checkout.scan book1

    expect( checkout.total ).to eq 24
  end

  it "discounts a set of two books by 5%" do

    checkout.scan book1
    checkout.scan book4

    expect( checkout.total ).to eq 16 * 0.95
  end

  it "discounts a set of three books by 10%" do
    book2 = OpenStruct.new name: 'book2', price: 8

    checkout.scan book1
    checkout.scan book2
    checkout.scan book4

    expect( checkout.total ).to eq 24 * 0.90
  end

  it "discounts a set of four books by 20%" do
    checkout.scan book1
    checkout.scan book2
    checkout.scan book3
    checkout.scan book4

    expect( checkout.total ).to eq 32 * 0.80
  end

  it "discount a set of five books by 25%" do
    checkout.scan book1
    checkout.scan book2
    checkout.scan book3
    checkout.scan book4
    checkout.scan book5

    expect( checkout.total ).to eq 40 * 0.75
  end

  it "does not discount books outside of the set" do
    checkout.scan book1
    checkout.scan book1
    checkout.scan book2

    expect( checkout.total ).to eq 8 + 16 * 0.95
  end

  it "handles finding the best discount" do
    checkout.scan book1
    checkout.scan book1
    checkout.scan book2
    checkout.scan book2
    checkout.scan book3
    checkout.scan book3
    checkout.scan book4
    checkout.scan book5

    expect( checkout.total ).to eq( 32 * 0.8 + 32 * 0.8 )
  end
end
