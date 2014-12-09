module PuppyBreeder
  class Breed
    attr_reader :name, :id
    attr_accessor :price
    
    def initialize(params)
      @name = params[:name]
      @price = params[:price] || 0
      @id = params[:id]
    end
  end
end