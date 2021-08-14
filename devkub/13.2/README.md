## Домашнее задание к занятию "13.2 разделы и монтирование"  
  
Ниже скрин с результатом установки helm и примером выданного конфига для создания PVC:  
![13.2_installed_helm.png](https://github.com/alsxs/devops_dz/blob/main/devkub/13.2/13.2_installed_helm.png)  
  
### Задание 1: подключить для тестового конфига общую папку  
  
В качестве базы для выполнения заданий, был взят набор файлов из задач предыдущей темы (13.1) и переработан под текущие условия заданий (в т.ч. выпилил все, что было связано с БД).  
Ниже текст скрипта по созданию общей папки для двух контейнеров в поде:
  
[task1.yaml:](https://github.com/alsxs/devops_dz/blob/main/devkub/13.2/task1.yaml)  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-backend
  namespace: stage
  labels:
    app: t1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: t1
  template:
    metadata:
      labels:
        app: t1
    spec:
      containers:
      - name: frontend
        image: nginx:latest
        ports:
        - containerPort: 80
        volumeMounts:
        - name: static
          mountPath: /static
      - name: backend
        image: python:3.9-buster        
        ports:
        - containerPort: 9000
        command: ["sleep", "7878"]
        volumeMounts:
        - name: static
          mountPath: /static
                  
      volumes:
      - name: static
        emptyDir: {}
```
  
Ниже выводы команд и результаты проверки:   
![13.2_task1.png](https://github.com/alsxs/devops_dz/blob/main/devkub/13.2/13.2_task1.png)  
  
  
### Задание 2: подключить общую папку для прода  
    
Ниже приведены скрипты для создания pvc и фронта с беком в разных подах с общей папкой:
  
[pvc-claim.yaml:](https://github.com/alsxs/devops_dz/blob/main/devkub/13.2/pvc-claim.yaml)  
```yaml
---
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
      name: pvc-claim
      namespace: prod
    spec:
      storageClassName: "nfs"
      accessModes:
        - ReadWriteMany
      resources:
        requests:
          storage: 100Mi
```
  
[task2_frontend.yaml:](https://github.com/alsxs/devops_dz/blob/main/devkub/13.2/task2_frontend.yaml)  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: t2-frontend
  namespace: prod
  labels:
    app: t2-frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: t2-frontend
  template:
    metadata:
      labels:
        app: t2-frontend
    spec:
      containers:
      - name: t2-frontend
        image: nginx:latest
        ports:
        - containerPort: 80
        env:
          - name: BASE_URL
            value: http://backend:9000
        volumeMounts:
        - mountPath: /static_prod
          name: pv-stor
      volumes:
      - name: pv-stor
        persistentVolumeClaim:
          claimName: pvc-claim
              
---
apiVersion: v1
kind: Service
metadata:
  name: t2-frontend
  namespace: prod
spec:
  type: ClusterIP
  selector:
    app: t2-frontend
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 80
```
  
[task2_backend.yaml:](https://github.com/alsxs/devops_dz/blob/main/devkub/13.2/task2_backend.yaml)  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: t2-backend
  namespace: prod
  labels:
    app: t2-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: t2-backend
  template:
    metadata:
      labels:
        app: t2-backend
    spec:
      containers:
      - name: t2-backend
        image: python:3.9-buster        
        ports:
        - containerPort: 9000
        command: ["sleep", "7878"]
        volumeMounts:
        - mountPath: /static_prod
          name: pv-stor
      volumes:
      - name: pv-stor
        persistentVolumeClaim:
          claimName: pvc-claim

---
apiVersion: v1
kind: Service
metadata:
  name: t2-backend
  namespace: prod
spec:
  type: ClusterIP
  selector:
    app: t2-backend
  ports:
    - protocol: TCP
      port: 9000
      targetPort: 9000
```
  
Ниже выводы команд и результаты проверки:   
![13.2_task2.png](https://github.com/alsxs/devops_dz/blob/main/devkub/13.2/13.2_task2.png)  

На всякий случай в папку вложены (продублированы) файлы с выводами из терминала в текстовом формате ([t1_outs.txt](https://github.com/alsxs/devops_dz/blob/main/devkub/13.2/t1_outs.txt) и [t2_outs.txt](https://github.com/alsxs/devops_dz/blob/main/devkub/13.2/t2_outs.txt)).  
  
  
  