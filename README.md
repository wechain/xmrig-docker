# Instructions
You can either use the image with Docker or on Kubernetes.

## using Docker
```docker
docker run --name xmrig-kernel --privileged --cap-add ALL -v /lib/modules:/lib/modules wentzien/xmrig:1.0.1
```

## using Kubernetes
* use kube-xmrig-deployment.yaml
* install on every node the required packages for max hashrate:
    ```bash
    sudo apt -y install kmod msr-tools
    ```
* deploy in namespace "xmrig":
    ```bash
    kubectl apply -f kube-xmrig-deployment.yaml -n xmrig
    ```
* show all pods:
    ```bash
    kubectl get pod -n xmrig
    ```
* show logs of a specific pod:
    ```bash
    kubectl logs <name-of-pod>

    # eg
    # kubectl logs xmrig-deployment-7b675997-9x4n9
    ```

Enjoy mining! :)
