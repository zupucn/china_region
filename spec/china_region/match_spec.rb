require "spec_helper"

describe ChinaRegion::Match do
  let(:match) { ChinaRegion::Match }
  it "should know the code is match or not" do
    expect(match.match?("")).to eq false
    expect(match.match?("110000")).to eq true
    expect(match.match?("1100000")).to eq false
    expect(match.match?("110000000")).to eq true
    expect(match.match?("110000000000")).to eq true
    expect(match.match?("1100000000000")).to eq false
  end

  it "could split the code" do
    expect(match.split("410100")).to eq %w(41 01 00)
    expect(match.split("410100000")).to eq %w(41 01 00 000)
    expect(match.split("410100000000")).to eq %w(41 01 00 000 000)
  end


  it "could compact the code" do
    expect(match.compact(%w(43 11 00))).to eq %w(43 11)
    expect(match.compact(%w(43 11 00 000))).to eq %w(43 11)
    expect(match.compact(%w(43 11 01 000 000))).to eq %w(43 11 01)
  end

  it "should know the code type" do
    expect(match.type_of("41").to_s).to eq "province"
    expect(match.type_of("4101").to_s).to eq "city"
    expect(match.type_of("410101").to_s).to eq "district"
    expect(match.type_of("410101001").to_s).to eq "street"
    expect(match.type_of("410101001001").to_s).to eq "community"
  end
end
