- Create Deployment with labels

`
kubectl run web --image=nginx --replicas=2 --labels="env=prod"
`

`
kubectl run proxy --image=nginx --replicas=2 --labels="env=dev"
`

- show labels

`
kubectl get deployments --show labels
`
