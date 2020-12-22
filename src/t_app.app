{
    application,t_app,
    [
        {vsn,"1.0"},
        {description,"Template application"},
        {modules,[t_app,t_sup,server]},
        {registered,[t_sup,server]},
        {applications,[kernel,stdlib]},
        {mod,{t_app,[]}},
        {env,[{listenPort,8080}]}
    ]
}