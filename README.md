# coffeeshop-on-dapr

The .NET coffeeshop application runs on Dapr

# Services

<table>
    <thead>
        <td>No.</td>
        <td>Service Name</td>
        <td>URI</td>
    </thead>
    <tr>
        <td>1</td>
        <td>product-service</td>
        <td>http://localhost:5001</td>
    </tr>
    <tr>
        <td>2</td>
        <td>counter-service</td>
        <td>http://localhost:5002</td>
    </tr>
    <tr>
        <td>3</td>
        <td>barista-service</td>
        <td>http://localhost:5003</td>
    </tr>
    <tr>
        <td>4</td>
        <td>kitchen-service</td>
        <td>http://localhost:5004</td>
    </tr>
    <tr>
        <td>5</td>
        <td>reverse-proxy (local development only)</td>
        <td>http://localhost:8080</td>
    </tr>
</table>

# Get starting

```bash
> dapr init
> docker compose up 
```

Finally, you can play around using [client.http](client.http) to explore the application!

> Make sure no `redis`, `zipkin` instances running

## Clean up

TODO

# Troubleshooting

## Couldn't run `sebp/elk:latest` on Docker (Windows 11 - WSL2 with Docker for Desktop integrated)

> error: elasticsearch_1  | max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

Jump into wsl2, then run command below

```
$ sudo sysctl -w vm.max_map_count=262144
```

Now, we can run `docker-compose up` again.

# References
