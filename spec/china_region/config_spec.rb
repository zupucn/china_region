require "spec_helper"

describe ChinaRegion::Config do
  let(:config) { ChinaRegion::Config.clone }
  let(:instance) { config.instance }

  it "has default orm" do
    expect(instance.orm).to eq :active_record
  end

  it "could use simple dsl config the application" do
    config.set do
      orm :test
      redis "redis"
      table_name "table name"
    end
    expect(instance.orm).to eq :test
    expect(instance.redis).to eq "redis"
    expect(instance.table_name).to eq "table name"
  end
end
