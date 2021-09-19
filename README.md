# Monero mining with xmrig

## Instructions
You can either use the image with Docker or on Kubernetes.

### using Docker
* install on the host the required packages for max hashrate:
    ```bash
    sudo apt -y install kmod msr-tools
    ```
* run container
    with default settings:
    ```docker
    docker run --name xmrig --privileged --cap-add ALL -v /lib/modules:/lib/modules wechain/xmrig:1.6.5
    ```
    with custom settings:
    ```docker
    docker run --name xmrig \
        --env pool=<host-and-port-of-mining-pool> \
        --env wallet_address=<your-wallet-address> \
        --env rig_id=<custom-rig-id-name> \
        --env donate_level=<donation-to-pool-in-percent> \
        --privileged \
        --cap-add ALL \wechain
        -v /lib/modules:/lib/modules \
        wechain/xmrig:1.6.5

    #eg
    sudo docker run --name xmrig \
        --env pool=sg.minexmr.com:443 \
        --env wallet_address=865kjopGVkABniUeparZntDDNDP3eMrVz1UFvBXSuTjb8ZfYTyQSt9GRsVeBFXhFCwK7zmqvh7a4dCrwSyo3r9GGNstLLR2 \
        --env rig_id="apac-1" \
        --env donate_level=0 \
        --privileged \
        --cap-add ALL \
        -v /lib/modules:/lib/modules \
        wechain/xmrig:1.6.5
    ```


### using Kubernetes
* use kube-xmrig-deployment.yaml
* install on every node the required packages for max hashrate:
    ```bash
    sudo apt -y install kmod msr-tools
    ```
* adjust env variable values in kube-xmrig-deployment.yaml
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
