require 'sinatra'
require 'slim'
require 'SQLite3'
require 'bcrypt'

enable :sessions

    get('/') do
        slim(:index)
    end

    get('/login') do
        slim(:login)
    end 

    post('/login') do
        db = SQLite3::Database.new("db/user.db")
        db.results_as_hash = true

        if BCrypt::Password.new == password
            redirect('/inloggad')
        else
            redirect('/login')
        end
    end 

    get('/registrering') do
        slim(:registrering)
    end

    post('/registrering') do 
        db = SQLite3::Database.new("db/user.db")
        db.results_as_hash = true

        name = params["name"]
        password = BCrypt::Password.create(params["password"])

        db.execute("INSERT INTO User (name,password) VALUES (?,?)",name,password)
        db.execute("SELECT id FROM User WHERE name = name",name)
        session[:id] = true
        redirect('/') 
    end