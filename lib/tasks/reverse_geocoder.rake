namespace :reverse_geocode do
  desc "Reverse geocode all objects without address."
  task :all => :environment do
    class_name = ENV['CLASS'] || ENV['class']
    sleep_timer = ENV['SLEEP'] || ENV['sleep']
    batch = ENV['BATCH'] || ENV['batch']
    raise "Please specify a CLASS (model)" unless class_name
    klass = class_from_string(class_name)
    batch = batch.to_i unless batch.nil?

    klass.not_reverse_geocoded.find_each(batch_size: batch) do |obj|
      obj.reverse_geocode; obj.save
      sleep(sleep_timer.to_f) unless sleep_timer.nil?
    end
  end
end

##
# Get a class object from the string given in the shell environment.
# Similar to ActiveSupport's +constantize+ method.
#
def class_from_string(class_name)
  parts = class_name.split("::")
  constant = Object
  parts.each do |part|
    constant = constant.const_get(part)
  end
  constant
end
