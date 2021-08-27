## Домашнее задание к занятию "14.3 Карты конфигураций"

### Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

#### Как создать карту конфигураций?

```
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap domain --from-literal=name=netology.ru
```
  
![14.3_1a.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.3/14.3_1a.png)  

  
#### Как просмотреть список карт конфигураций?

```
kubectl get configmaps
kubectl get configmap
```
  
![14.3_1b.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.3/14.3_1b.png)  

  
#### Как просмотреть карту конфигурации?

```
kubectl get configmap nginx-config
kubectl describe configmap domain
```
  
![14.3_1c.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.3/14.3_1c.png)  

  
#### Как получить информацию в формате YAML и/или JSON?

```
kubectl get configmap nginx-config -o yaml
kubectl get configmap domain -o json
```
  
![14.3_1d.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.3/14.3_1d.png)  

  
#### Как выгрузить карту конфигурации и сохранить его в файл?

```
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml
```
  
![14.3_1e.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.3/14.3_1e.png)  

  
#### Как удалить карту конфигурации?

```
kubectl delete configmap nginx-config
```
  
![14.3_1f.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.3/14.3_1f.png)  

  
#### Как загрузить карту конфигурации из файла?

```
kubectl apply -f nginx-config.yml
```
  
![14.3_1g.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.3/14.3_1g.png)  

  

