#Refer to this class as PuppyBreeder::Puppy
module PuppyBreeder
  class Puppy
    attr_reader :name, :breed
    attr_accessor :status
    
    def initialize(params)
      @name = params[:name]
      @breed = params[:breed]
      @status = params[:status] || 'available'
      @id = params[:id]
    end
  end
end