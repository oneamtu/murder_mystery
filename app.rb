require "sinatra"
require "sinatra/reloader" if development?
# require "pry-rescue"

require "./submission.rb"

DataMapper.finalize

enable :sessions

use Rack::Auth::Basic, "Look in the bathroom" do |username, password|
  username == 'Investigator' and password == '206hollandst'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

SUSPECTS = %w[
  mr_green
  ms_peacock
  col_mustard
  prof_plum
  ms_scarlet
  dr_orchid
]

get '/' do
  haml :main, locals: { submitted: session[:submitted], guessed_right: session[:guessed_right] }
end

get '/victim' do
  haml :victim
end

get '/suspects/:name' do
  if SUSPECTS.include?(params[:name])
    haml params[:name].to_sym
  else
    redirect to('/')
  end
end

post '/submit' do
  session[:submitted] = true

  guessed_right = params[:weapon] == "poison" && params[:suspect] == "prof_plum"
  session[:guessed_right] = guessed_right

  Submission.create(
    name: params[:name],
    weapon: params[:weapon],
    suspect: params[:suspect],
    comment: params[:comment],
    success: guessed_right,
    submitted_at: DateTime.now
  )

  if guessed_right
    redirect to("/submissions")
  else
    render :haml, <<~HTML
      :markdown
        Thank you for your contribution. Unfortunately, it does not align with our current leads.

        Enjoy the rest of your night.

        The Brother Odd Police.

        [back](/)
    HTML
  end
end

get '/submissions' do
  haml :submissions, locals: { submissions: Submission.all(success: true) }
end
