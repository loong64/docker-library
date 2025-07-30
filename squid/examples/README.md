# Running the examples

## docker-compose

Install `docker-compose` from the Ubuntu archive:

```
$ sudo apt install -y docker-compose
```

Call `docker-compose` from the examples directory:

```
$ docker-compose up -f docker-compose.yml -d
```

You can now squid squid at `localhost:3128`

To stop `docker-compose`, run:

```
$ docker-compose -f docker-compose.yml down
```

# Microk8s

Install microk8s from snap:

```
$ snap install microk8s --classic
```

With microk8s running, enable the `dns` and `storage` add-ons:

```
$ microk8s enable dns storage
```

Create a configmap for the configuration files:

```
$ microk8s kubectl create configmap squid-config \
		--from-file=squid=config/squid.conf \
```

Apply the `squid-deployment.yml`:

```
$ microk8s kubectl apply -f squid-deployment.yml
```

You can now use the squid proxy on port `3128` (e.g., `https_proxy=localhost:3128 curl https://ubuntu.com`)
