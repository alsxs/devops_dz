## Домашнее задание к занятию "14.4 Сервис-аккаунты"

### Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

#### Как создать сервис-аккаунт?

```
kubectl create serviceaccount netology
```
  
![14.4_1a.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.4/14.4_1a.png)  

  
#### Как просмотреть список сервис-акаунтов?

```
kubectl get serviceaccounts
kubectl get serviceaccount
```
  
![14.4_1b.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.4/14.4_1b.png)  

  
#### Как получить информацию в формате YAML и/или JSON?

```
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
```
  
![14.4_1c.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.4/14.4_1c.png)  

  
#### Как выгрузить сервис-акаунты и сохранить его в файл?

```
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
```
  
![14.4_1d.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.4/14.4_1d.png)  

  
#### Как удалить сервис-акаунт?

```
kubectl delete serviceaccount netology
```
  
![14.4_1e.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.4/14.4_1e.png)  

  
#### Как загрузить сервис-акаунт из файла?

```
kubectl apply -f netology.yml
```
  
![14.4_1f.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.4/14.4_1f.png)  
  
Если честно, то не совсем понял, почему (или зачем) при восстановлении из файла появился дополнительный секрет.

---
