require "spec_helper"

describe ChinaRegion::Region do
  let!(:province){ ChinaRegion::Region.create(code: "430000",name: "湖南省") }
  let!(:city){ ChinaRegion::Region.create(code: "430100", name: "长沙市") }
  let!(:district){ ChinaRegion::Region.create(code: "430102", name: "芙蓉区") }
  let!(:street){ ChinaRegion::Region.create(code: "430102003", name: "韭菜园街道") }
  let!(:community){ ChinaRegion::Region.create(code: "430102003003", name: "八一桥社区") }

  it "has correct parent code" do
    expect(province.parent_code).to eq "000000"
    expect(city.parent_code).to eq "430000"
    expect(district.parent_code).to eq "430100"
    expect(street.parent_code).to eq "430102"
    expect(community.parent_code).to eq "430102003"
  end

  it "has correct short_code code" do
    expect(province.short_code).to eq "43"
    expect(city.short_code).to eq "4301"
    expect(district.short_code).to eq "430102"
    expect(street.short_code).to eq "430102003"
    expect(community.short_code).to eq "430102003003"
  end

  it "has correct full code" do
    expect(province.full_code).to eq "430000000000"
    expect(community.full_code).to eq "430102003003"
  end

  it "has children" do
    expect(province.cities.first).to eq city
    expect(province.streets.first).to eq street
    expect(province.communities.first).to eq community
    expect(district.streets.first).to eq street
  end
end
