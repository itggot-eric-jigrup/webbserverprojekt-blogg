require 'sinatra'
require 'slim'
require 'SQLite3'
require 'bcrypt'
require 'byebug'

enable :sessions

    get('/') do
        slim(:index)
    end

    get('/login') do
        slim(:login)
    end 

    post('/login') do
        username = params["name"]
        pswrd = params["password"]

        db = SQLite3::Database.new("db/user.db")
        db.results_as_hash = true

        password = db.execute("SELECT password FROM User WHERE name = ?", username)

        password = password.first["password"]

        p"PASSWORD:#{password}"
        if BCrypt::Password.new(password) == pswrd
            session[:username] = username
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
        result = db.execute("SELECT id FROM User WHERE name = ?",name)
        
        p result
        session[:id] = result.first.first
        redirect('/') 
    end

    get('/secure') do
        p session[:id]
        if session[:id] != nil
            return "You got in"
        else
            redirect('/login')
        end
    end

    get('/inloggad') do 
        slim(:inloggad)
    end

    post('/inloggad') do
        db = SQLite3::Database.new("db/user.db")
        db.results_as_hash = true
    end

    get('/profil') do
        slim(:profil)
    end

    post('/profil') do
        db = SQLite3::Database.new("db/user.db")
        db.results_as_hash = true
    end