# TcpApp
TCP Server using behaviours and distributed erlang.

Coposed of :<br>
 application<br>
 main supervisor<br>
    gen_server (handles new connections and stores connected client pids for inspection)<br>
    worker supervisor (manages workers)<br>
    worker - keeps a live connection with a client via socket<br>
