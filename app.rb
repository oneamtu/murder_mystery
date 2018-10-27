require "sinatra"
require "sinatra/reloader" if development?

enable :sessions

SUSPECTS = %w[
  mr_green
  ms_peacock
  col_mustard
  prof_plum
  ms_scarlet
  dr_orchid
]

# TODO: character sites
# TODO: character pics
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

# TODO: who finished
post '/submit' do
  session[:submitted] = true

  if params[:weapon] == "poison" && params[:suspect] == "prof_plum"
    session[:guessed_right] = true
    render :haml, <<~HTML
      :markdown
        You are correct. This is in line with our suspicions.

        Thank you for doing your duty.

        Enjoy the rest of your night.

        The Brother Odd Police.

        [back](/)
    HTML
  else
    session[:guessed_right] = false

    render :haml, <<~HTML
      :markdown
        Thank you for your contribution. Unfortunately, it does not align with our current leads.

        Enjoy the rest of your night.

        The Brother Odd Police.

        [back](/)
    HTML
  end
end
