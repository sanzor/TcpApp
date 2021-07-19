# TcpApp
TCP Server using behaviours and distributed erlang.

Coposed of :
 -application
  -main supervisor
    -gen_server (handles new connections and stores connected client pids for inspection)
    - worker supervisor (manages workers)
      -worker - keeps a live connection with a client via socket
