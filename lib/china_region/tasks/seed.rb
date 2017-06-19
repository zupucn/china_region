namespace :china_region do
  task :seed do
    ChinaRegion::Region.init_db
  end
end
