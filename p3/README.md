Extra step add "127.0.0.1 app1.com" to /etc/hosts

to get login key 

kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d; echo


--------------------------------------------


Then follow this 

https://argo-cd.readthedocs.io/en/stable/getting_started/