{application,sockapp,
             [{vsn,"1.0.0"},
              {description,"Erlang distributed socket server"},
              {modules,[main_sup,sock_app,sock_worker,worker_sup]},
              {applications,[stdlib,kernel]},
              {registered,[main_sup,worker_sup]},
              {env,[{acceptorCount,3},{listenPort,8300}]},
              {mod,{sock_app,[]}}]}.
