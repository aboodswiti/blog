class HelloJob
  include Sidekiq::Job

  def perform(*args)
    # Do something
    puts "Hello World!"
  end
end
