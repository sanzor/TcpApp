erlc -o ebin  src/*.erl
erl -pa ebin -eval "application:start(sockapp),application:loaded_applications()."
