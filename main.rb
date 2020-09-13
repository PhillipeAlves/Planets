require 'sinatra'
# require 'sinatra/reloader'
require "pg"


# MAIN PAGE

get "/" do

  db = PG.connect(dbname: 'planets_app')

  result = db.exec("SELECT * FROM planets WHERE id = 12;")

  earth = result.first
  db.close

  erb :index, locals: { earth: earth }

end

# ERROR

get "/error/:id" do

  db = PG.connect(dbname: 'planets_app')

  result = db.exec("SELECT * FROM planets WHERE id = #{ params["id"]};")

  error = result.first

  db.close

  erb :error, locals: { error: error }

end

# GET PLANETS

get "/planets" do

  db = PG.connect(dbname: 'planets_app')

  planets = db.exec("SELECT * FROM planets;")

  db.close

  erb :planets, locals: { planets: planets }

end


# ADD PLANET - GET

get '/add_planet' do

  erb :add_planet

end


# ADD PLANET - POST

post '/planets' do

  if params["name"] != "" && params["image_url"] != ""
    
    db = PG.connect(dbname: 'planets_app')

    sql = db.exec("INSERT into planets (name, image_url) values ('#{ params["name"] }', '#{ params["image_url"] }');")
          
    db.close
  
  end

  redirect "/planets"

end


# PLANET - GET

get '/planet/:id' do

  db = PG.connect(dbname: 'planets_app')

  result = db.exec("SELECT * FROM planets WHERE id = #{ params["id"] };")

  planet = result.first

  db.close

  erb :planet, locals: { planet: planet }

end


# PLANET - DELETE

delete '/planet' do

  db = PG.connect(dbname: 'planets_app')

  sql = "DELETE FROM planets WHERE id = #{ params["id"]};"

  db.exec(sql)
        
  db.close

  redirect "/planets"
  
end


# PLANET UPDATE - GET

get '/planet/:id/edit_planet' do

  
  db = PG.connect(dbname: 'planets_app')

  sql = "SELECT * FROM planets WHERE id = #{ params["id"]};"
  
  results = db.exec(sql)

  edit_planet = results.first

  db.close

  erb :edit_planet, locals: { edit_planet: edit_planet }

end


# PLANET UPDATE - PATCH

patch '/planet/:id' do

  number_pattern = /\A[-+]?[0-9]*\.?[0-9]+\Z/

  if  params["moon_count"] !~ number_pattern && params["moon_count"] != ""

    redirect "/error/#{params["id"]}"

  elsif params["diameter"] !~ number_pattern && params["diameter"] != ""

    redirect "/error/#{params["id"]}"

  elsif params["mass"] !~ number_pattern && params["mass"] != ""

    redirect "/error/#{params["id"]}"

  elsif 

    db = PG.connect(dbname: 'planets_app')

    diameter = params["diameter"]
    full_diameter = diameter.gsub(/[\s,(km)]/ ,"")
  
    # sql = "UPDATE planets SET "
    #   if !params["name"].empty?
    #   sql += "name = '#{ params["name"]}', "
    # end
    #   if !params["diameter"].empty?
    #   sql += "diameter = '#{ params["diameter"]}', "
    # end
    #   if !params["mass"].empty?
    #   sql += "mass = #{ params["mass"]}, "
    # end
    #   if !params["moon_count"].empty?
    #   sql += "moon_count = #{ params["moon_count"]}, "
    # end
    # if !params["image_url"].empty?
    #   sql += "image_url = #{ params["image_url"]}, "
    # end

    if params["name"] != "" && params["imade_url"] != "" && full_diameter != "" && params["mass"] != "" && params["moon_count"] != ""
  
      sql = "UPDATE planets SET name = '#{ params["name"]}', image_url = '#{ params["image_url"]}', diameter = '#{ full_diameter }', mass = '#{ params["mass"]}', moon_count = '#{ params["moon_count"]}' WHERE id = #{ params["id"]};"
  
    elsif params["name"] != "" && params["imade_url"] != "" && params["mass"] != "" && params["moon_count"] != ""
  
      sql = "UPDATE planets SET name = '#{ params["name"]}', image_url = '#{ params["image_url"]}', mass = '#{ params["mass"]}', moon_count = '#{ params["moon_count"]}' WHERE id = #{ params["id"]};"
  
    elsif params["name"] != "" && params["imade_url"] != "" && full_diameter != "" && params["mass"] != ""
  
      sql = "UPDATE planets SET name = '#{ params["name"]}', image_url = '#{ params["image_url"]}', diameter = '#{ full_diameter}', mass = '#{ params["mass"]}' WHERE id = #{ params["id"]};"
  
    elsif params["name"] != "" && params["imade_url"] != "" && full_diameter != ""
  
      sql = "UPDATE planets SET name = '#{ params["name"]}', image_url = '#{ params["image_url"]}', diameter = '#{ full_diameter}' WHERE id = #{ params["id"]};"
  
    elsif params["name"] != "" && params["imade_url"] != "" && params["mass"] != ""
  
      sql = "UPDATE planets SET name = '#{ params["name"]}', image_url = '#{ params["image_url"]}', mass = '#{ params["mass"]}' WHERE id = #{ params["id"]};"
  
    elsif params["name"] != "" && params["imade_url"] != "" && params["moon_count"] != ""
  
      sql = "UPDATE planets SET name = '#{ params["name"]}', image_url = '#{ params["image_url"]}', moon_count = '#{ params["moon_count"]}' WHERE id = #{ params["id"]};"
  
    elsif params["name"] != "" && params["imade_url"] != ""
  
      sql = "UPDATE planets SET name = '#{ params["name"]}', image_url = '#{ params["image_url"]}' WHERE id = #{ params["id"]};"
    
    else params["name"] != ""
  
      sql = "UPDATE planets SET name = '#{ params["name"]}' WHERE id = #{ params["id"]};"
    
    end
  
    results = db.exec(sql)
  
    db.close
  
    redirect "/planet/#{params["id"]}"
  
  end

end






