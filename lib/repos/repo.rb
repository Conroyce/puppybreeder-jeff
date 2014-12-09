require 'pg'

module PuppyBreeder::Repos
  class Repo
    def initialize
      @db = PG.connect(dbname: 'puppy-breeder')
    end 
  end   
end  