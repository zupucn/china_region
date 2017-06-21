require "spec_helper"

describe ChinaRegion::Region do
  describe 'Function test' do
    let!(:province){ ChinaRegion::Region.create(code: "43",name: "湖南省") }
    let!(:city){ ChinaRegion::Region.create(code: "4301", name: "长沙市") }
    let!(:district){ ChinaRegion::Region.create(code: "430102", name: "芙蓉区") }
    let!(:street){ ChinaRegion::Region.create(code: "430102003", name: "韭菜园街道") }
    let!(:community){ ChinaRegion::Region.create(code: "430102003003", name: "八一桥社区") }

    it "has correct parent code" do
      expect(province.parent_code).to eq ""
      expect(city.parent_code).to eq "43"
      expect(district.parent_code).to eq "4301"
      expect(street.parent_code).to eq "430102"
      expect(community.parent_code).to eq "430102003"
    end


    it "has correct full code" do
      expect(province.full_code).to eq "430000"
      expect(community.full_code).to eq "430102003003"
    end

    describe ChinaRegion::Query do
      it "has sub regions" do
        expect(province.cities).to eq [city]
        expect(province.streets).to eq [street]
        expect(province.districts).to eq [district]
        expect(province.communities).to eq [community]
        expect(district.streets).to eq [street]
      end

      it "has parent" do
        expect(city.parent).to eq province
      end

      it "has children" do
        expect(province.children).to eq [city]
        expect(city.children).to eq [district]
        expect(district.children).to eq [street]
        expect(street.children).to eq [community]
      end

      it "has regions" do
        expect(ChinaRegion::Region.provinces).to eq [province]
        expect(ChinaRegion::Region.cities).to eq [city]
        expect(ChinaRegion::Region.districts).to eq [district]
        expect(ChinaRegion::Region.streets).to eq [street]
        expect(ChinaRegion::Region.communities).to eq [community]
      end

      it "has a region for specify code" do
        expect(ChinaRegion::Region.regions_of("43")).to eq [city]
      end

      it "has sub regions for specify code" do
        expect(ChinaRegion::Region.cities_of("43")).to eq [city]
        expect(ChinaRegion::Region.districts_of("43")).to eq [district]
        expect(ChinaRegion::Region.communities_of("43")).to eq [community]
      end

    end
  end

  it "could import data from csv" do
    ChinaRegion::Region.init_db
    expect(ChinaRegion::Region.count).to eq 699619
  end
end
