Para poder correr kubernetes en PROD en On-premise, hay muchas formas de hacer y una de ellas es usar kubadm, aqui explicaremos como hacerlo.

# Instalar kubeadm, docker, kubectl y kubelet

`
chmod +x install_kubeadm.sh
./install_kubeadm.sh
`

# En master:
------------

- Levantar el cluster de kubernetes

`
kubeadm init
`  

- Correr el comando kubectl con usuario non-root

`
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
`

- Anadir el node Network (en este caso sera calico):

`
kubectl apply -f https://docs.projectcalico.org/latest/manifests/calico.yaml
`


# En el nodo:
-------------

En el nodo utilizar el resultado que obtuvimos al ejecutar el kubeadmin init en el master que seria kubeadmn join....

`
kubeadm join 10.132.0.13:6443 --token q7vnav.i1gzk2pepb0bm84f \
	--discovery-token-ca-cert-hash sha256:ba0ffaaeea5cf76b6504cf41da60238a4a26b3a1e09a370f18e7e2849f3269a9
` 

(el comando de arriba es solo un ejemplo, seguramente en vuestro caso seria uno diferente.)



# Troubleshooting



# Deployar una aplicacion:

` 
kubectl apply -f deployment.yaml
`

# Ver el resultado y cuantos nodos tenemos

`
kubectl get pod
`

# Vamos a ver en que nodos estan con el comando:

`
kubectl get pod -o wide
`







