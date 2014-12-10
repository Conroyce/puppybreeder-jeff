module PuppyBreeder::Repos
  class Puppies < Repo
    # def initialize
    #   @puppies = {}
    # end

    def create_table
      command = <<-SQL
      CREATE TABLE if not exists puppies(
        id SERIAL PRIMARY KEY,
        name text,
        breed text,
        status text
      );
      SQL
      result = @db.exec(command)
    end 

    # def create_table
    #   command = <<-SQL
    #   CREATE TABLE if not exists puppies(
    #     id SERIAL PRIMARY KEY,
    #     name text,
    #     breedID integer REFERENCES breeds(id),
    #     status text
    #     );
    #     SQL
    #     result = @db.exec(command)
    # end 

    def drop_table
      command = <<-SQL
      DROP TABLE if exists puppies
      SQL
      result = @db.exec(command)
    end  

    def create(params)
      name = params[:name]
      breed = params[:breed]
      id = params[:id]
      status = params[:status] || "available"
      if (breed.class == PuppyBreeder::Breed)
        command = <<-SQL
          INSERT INTO puppies(name,breed,status)
          VALUES ('#{name}','#{breed.name}','#{status}')
          RETURNING *;
        SQL
        result = @db.exec(command)
        build_puppy(result.first)
      else 
       breed_obj = PuppyBreeder.breeds_repo.find_by({name: breed}).first
        if !breed_obj
          breed_obj = PuppyBreeder.breeds_repo.create({name: breed})
        end 
        # puppy = PuppyBreeder::Puppy.new({
        #   name: name,
        #   breed: breed_obj,
        #   id: id
        # })
        command = <<-SQL
          INSERT INTO puppies(name,breed)
          VALUES ('#{name}','#{breed_obj.name}')
          RETURNING *;
        SQL
        result = @db.exec(command)
        build_puppy(result.first)
      end 
    end 

    def build_puppy(params)
      id = params["id"].to_i
      name = params["name"]
      breed = PuppyBreeder.breeds_repo.find_by({name: params["breed"]}).first
      status = params["status"]
      PuppyBreeder::Puppy.new({
        id: id,
        name: name,
        breed: breed,
        status: status
      })
    end 

    # def create(params)
    #   name = params[:name]
    #   name_sym = name.to_sym
    #   breed = params[:breed]
    #   if(breed.class == PuppyBreeder::Breed)
    #     puppy = PuppyBreeder::Puppy.new(params)
    #     @puppies[name_sym] = puppy
    #   else
    #     breed_obj = PuppyBreeder.breeds_repo.find_by({name: breed}).first
    #     if !breed_obj
    #       breed_obj = PuppyBreeder.breeds_repo.create({name: breed})
    #     end
    #     puppy = PuppyBreeder::Puppy.new({
    #       name: name,
    #       breed: breed_obj
    #     })
    #     @puppies[name_sym] = puppy
    #   end
    # end

    # def filter(type, spec = '')
    #   array = []
    #   @puppies.each do |key, puppy|
    #     if type == 'name' && puppy.name == spec
    #       array << puppy
    #     elsif type == 'breed' && puppy.breed.name == spec
    #       array << puppy
    #     elsif type == 'status' && puppy.status == spec
    #       array << puppy
    #     elsif type == 'all'
    #       array << puppy
    #     end
    #   end
    #   array
    # end

    def find_by(params = {})
      name = params[:name]
      breed = params[:breed]
      status = params[:status]
      if breed.class == PuppyBreeder::Breed
        breed = breed.name
      end

      if name 
        command = <<-SQL
          SELECT * 
          FROM puppies 
          WHERE name = '#{name}'
        SQL
      elsif breed 
        command = <<-SQL
          SELECT *
          FROM puppies
          WHERE breed = '#{breed}'
        SQL
      elsif status
        command = <<-SQL
          SELECT *
          FROM puppies
          WHERE status = '#{status}'
        SQL
      else  
        command = <<-SQL
          SELECT *
          FROM puppies
        SQL
      end
      result = @db.exec(command)
      result.map { |x| build_puppy(x) }
    end  

    # def find_by(params = {})
    #   name = params[:name]
    #   breed = params[:breed]
    #   status = params[:status]
    #   if breed.class == PuppyBreeder::Breed
    #     breed = breed.name
    #   end

    #   if name
    #     array = filter('name', name)
    #   elsif breed
    #     array = filter('breed', breed)
    #   elsif status
    #     array = filter('status', status)
    #   else
    #     array = filter('all')
    #   end
    # end

    def update(params)
      name = params[:name]
      status = params[:status]
      command = <<-SQL
      UPDATE puppies
      SET status = '#{status}'
      WHERE name = '#{name}'
      RETURNING *;
      SQL
      result = @db.exec(command)
      build_puppy(result.first)
    end  

    # def update(params)
    #   name = params[:name].to_sym
    #   status = params[:status]
    #   @puppies[name].status = status
    #   @puppies[name]
    # end
  end
end