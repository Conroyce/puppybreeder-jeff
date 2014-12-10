module PuppyBreeder::Repos
  class Breeds < Repo
  
    def create_table
      command = <<-SQL
      CREATE TABLE if not exists breeds(
      id SERIAL PRIMARY KEY,
      name text,
      price text
      );
      SQL
      result = @db.exec(command)
    end 

    def drop_table
      command = <<-SQL
      DROP TABLE if exists breeds    
      SQL
      result = @db.exec(command)
    end  

    def create(params)
      name = params[:name]
      price = params[:price]
      command = <<-SQL
        INSERT INTO breeds(name,price)
        VALUES ('#{name}','#{price}')
        RETURNING *;
      SQL
      result = @db.exec(command)
      build_breed(result.first)
    end

    def build_breed(params)
      id = params["id"].to_i
      name = params["name"]
      price = params["price"].to_i
      PuppyBreeder::Breed.new({
        id: id,
        name: name,
        price: price
      })

    end    

    def find_by(params)
      name = params[:name]
      command = <<-SQL
      SELECT * FROM breeds WHERE name = '#{name}'
      SQL
      result = @db.exec(command)
      result.map { |x| build_breed(x) } 
    end  

    def update(params)
      key = params[:name]
      price = params[:price]
      command = <<-SQL
      UPDATE breeds
      SET price = '#{price}'
      WHERE name='#{key}'
      RETURNING *;
      SQL
      result = @db.exec(command)
      build_breed(result.first)
    end  

  end
end































