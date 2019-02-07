require 'sinatra'
require 'slim'
require 'SQLite3'

    get('/') do
        slim(:start)
    end

    get('/login') do
        slim(:login)
    end 

    post('/login') do
    end 