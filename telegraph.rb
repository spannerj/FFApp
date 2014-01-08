require 'sinatra/base'
#require "sinatra/reloader"
require 'pg'

class FFApp < Sinatra::Base
  # configure :development do
  #   register Sinatra::Reloader
  # end

	before do
		$conn = PGconn.connect('localhost', '5432', '', '', 'lrff', 'postgres', '')
		$teams = $conn.exec("select distinct team from players order by 1")
		#p params
	end

	get '/players' do
		if not params[:team].nil? #team
			team = params[:team]
	  		$res = $conn.exec_params("select player_id, player_name, player_position, player_value, team, player_link 
	  							  	from players where team = $1 order by 1;", [team])
	  	end

	  	if not params[:pos].nil? #all players
	  		pos = params[:pos]
		  	$res = $conn.exec_params("select player_id, player_name, player_position, player_value, team, player_link 
		  	 						  from players where player_position = $1 order by 1;", [pos])
		end
		  	 	
	  	if (params[:pos].nil? and params[:team].nil?)
			$res = $conn.exec("select player_id, player_name, player_position, player_value, team, player_link from players order by 1;")
	  	end

	 	erb :telegraph
	end
end