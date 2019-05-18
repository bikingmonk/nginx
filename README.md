# Nginx
- Asynchronous, Event-driven
- High throughput and concurrency
- Low memory footprint (2.5 MB per 10k inactive HTTP keep-alive connections)

## Todo
- rate limiting
- caching
- load balancing

## Setup
```
docker-compose up -d
```

## Setup (manual)
```
docker system prune -af --volumes
```

```
docker container run -it --rm -p 80:80 centos:centos7 bash
```

```
docker container run --rm -d -p 80:80 -p 443:443 --name proxy \
-v $(pwd)/config/nginx.conf:/etc/nginx/nginx.conf:ro \
-v $(pwd)/config/server_http.conf:/etc/nginx/server_http.conf:ro \
-v $(pwd)/config/server_https.conf:/etc/nginx/server_https.conf:ro \
-v $(pwd)/config/ssl:/etc/nginx/ssl:ro \
-v $(pwd)/config/.htpasswd:/etc/nginx/.htpasswd:ro \
-v $(pwd)/public:/etc/nginx/html:ro \
nginx:1.0.0
```

```
docker image build -t nginx:1.0.0 . --no-cache=true
```

### Generate files htpasswd file for Basic auth
```
htpasswd -c .htpasswd admin
```

### Generate self-signed SSL certificate
```
openssl req -x509 -days 365 -nodes -newkey rsa:2048 -sha256 -out localhost.crt -keyout localhost.key \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
```

```
open /Applications/Utilities/Keychain\ Access.app localhost.crt
```

### Generate Diffie-Hellman key
```
openssl dhparam 2048 -out dhparam.pem
```

## Other
```
docker exec -it proxy nginx -s reload

docker exec -it proxy bash

curl -ku admin:pass -D - https://localhost/info

ab -n 100 -c 10 http://localhost

siege -g https://localhost/info

siege -c 10 -r 1 https://localhost/info

while sleep 1; do curl -s http://localhost > /dev/null; done

curl -k https://localhost/info

siege -v -r2 -c5 http://localhost/info

ps -ef | grep nginx | grep master | awk '{print $2}'

curl -I -H "Accept-Encoding: gzip, deflate" http://localhost/bootstrap.css
```

## Links
https://github.com/fcambus/nginx-resources

https://github.com/nghttp2/nghttp2

https://github.com/lebinh/ngxtop

https://goaccess.io/