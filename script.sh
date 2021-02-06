erlc -o ebin  src/*.erl
erl -pa ebin -eval "application:start(sockapp),application:loaded_applications()."
# logger:add_handler(my_disk_log, logger_std_h,  #{config=>#{file=>"d:/mylog.log"}, level=>warning, formatter=>{logger_formatter, #{single_line=>true, time_offset=>0}}}).
# logger:warning("testing")
#http://erlang.org/doc/apps/kernel/logger_chapter.html#example--add-a-handler-to-log-info-events-to-file