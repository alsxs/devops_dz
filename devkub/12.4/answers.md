## Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"  

### Задание 1: Подготовить инвентарь kubespray  

Ниже привожу скрины настроек примененных для использования containerd вместо docker.  

![containerd](https://github.com/alsxs/devops_dz/blob/main/devkub/12.4/containerd_yaml.png)    
  
![etcd](https://github.com/alsxs/devops_dz/blob/main/devkub/12.4/etcd_for_containerd.png)  
  
![k8s_cluster](https://github.com/alsxs/devops_dz/blob/main/devkub/12.4/k8s_cluster_containerd.png)  
  
Команда запуска  
  
![command](https://github.com/alsxs/devops_dz/blob/main/devkub/12.4/command.png)  
  
Необходимо отметить, что не смотря на идею максимального упрощения развертывания, изначальная настройка и исправление кучи ошибок неизбежны. В том числе, фактически, по неизвестным
мне причинам должным образом не отработала часть настроек, указанных выше и пришлось параметры указывать явным образом в инвентаре. Ниже привожу финальную версию.  
  
![inventory](https://github.com/alsxs/devops_dz/blob/main/devkub/12.4/inventory.png)  
  
Результат отработки. Проигнорирована одна таска (на сколько я понял, это таска верификации работы деплоинга, но не проходит из-за отсутствия неймспейса, который обычно создается во время работы, но не развертывания).  
  
![ok_cluster](https://github.com/alsxs/devops_dz/blob/main/devkub/12.4/ok_cluster.png)  

