#/bin/sh
kubectl apply -f 00-role.yaml \
              -f 00-account.yaml \
              -f 01-role-binding.yaml \
              -f 02-traefik.yaml \
              -f 02-traefik-services.yaml