namespace :china_region do
  task :seed, [:batch_size] => [:environment]  do |_ , args|
    ChinaRegion::Region.init_db(args[:batch_size] || 500)
  end
end
