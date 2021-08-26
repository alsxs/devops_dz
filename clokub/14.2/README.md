## Домашнее задание к занятию "14.2 Синхронизация секретов с внешними сервисами. Vault"  

### Задача 1: Работа с модулем Vault  
  

Запустить модуль Vault конфигураций через утилиту kubectl в установленном minikube  

***Ниже скрин с запуском модуля vault, получением IP и запуском клиента***  
  
![14.2_1a.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.2/14.2_1a.png)  
  
Конфигурация запуска vault:
```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: 14.2-netology-vault
  namespace: vault
spec:
  containers:
  - name: vault
    image: vault
    ports:
    - containerPort: 8200
      protocol: TCP
    env:
    - name: VAULT_DEV_ROOT_TOKEN_ID
      value: "xxxxxxxxxxxx001"
    - name: VAULT_DEV_LISTEN_ADDRESS
      value: 0.0.0.0:8200
```
  
***Далее скрин с демонстрацией авторизации, записи секрета и чтения***  
  
![14.2_1b.png](https://github.com/alsxs/devops_dz/blob/main/clokub/14.2/14.2_1b.png)  
     
---
