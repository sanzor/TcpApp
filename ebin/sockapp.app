{
    application,sockapp,
    [
        {vsn,"1.0"},
        {description,"Template application"},
        {modules,[sock_app,main_sup,worker_sup]},
        {registered,[main_sup,server]},
        {applications,[kernel,stdlib]},
        {mod,{sock_app,[]}},
        {env,[{listenPort,8080},{acceptorCount,20}]}
    ]
}.