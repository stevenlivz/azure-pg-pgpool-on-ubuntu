Postgres with 1 x Master and 2 x Slave using Streaming Replication and 2 x PGPool (using a load balancer with a private ip - had issues with a public ip lb) in front and Watchdog.

See http://www.pgpool.net/pgpool-web/contrib_docs/watchdog/en.html


![http://www.pgpool.net/pgpool-web/contrib_docs/watchdog/watchdog.png](http://www.pgpool.net/pgpool-web/contrib_docs/watchdog/watchdog.png)


Based on https://github.com/Azure/azure-quickstart-templates/tree/d598c1381e00ca7432cab56c71ae56a49351a709/postgresql-on-ubuntu
