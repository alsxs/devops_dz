## Домашнее задание к занятию "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"  

### Задание 1: подготовить тестовый конфиг для запуска приложения  
  
Тестовый конфиг представлен ниже в двух файлах:  
[t1-frontend-backend.yaml:](https://github.com/alsxs/devops_dz/blob/main/devkub/13.1/t1-frontend-backend.yaml)  
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
      - name: backend
        image: python:3.9-buster        
        ports:
        - containerPort: 9000
        command: ["sleep", "7878"]
```  
  
[t1-bd-ss-svc.yaml:](https://github.com/alsxs/devops_dz/blob/main/devkub/13.1/t1-bd-ss-svc.yaml)  
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: t1-db
  namespace: stage
spec:
  selector:
    matchLabels:
      app: t1-db
  serviceName: "t1-db-serv"
  replicas: 1
  template:
    metadata:
      labels:
        app: t1-db
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - image: postgres:13-alpine
        name: t1-db
        env:
          - name: POSTGRES_PASSWORD
            value: postgres
          - name: POSTGRES_USER
            value: postgres
          - name: POSTGRES_DB
            value: news
        ports:
        - containerPort: 5432
---
apiVersion: v1
kind: Service
metadata:
  name: t1-db-serv
  namespace: stage
  labels:
    app: t1-db
spec:
  type: ClusterIP
  selector:
    app: t1-db
  ports:
    - protocol: TCP
      port: 5432
      targetPort: 5432
```
  
![13.1_t1](https://github.com/alsxs/devops_dz/blob/main/devkub/13.1/13.1_t1.png)
  
### Задание 2: подготовить конфиг для production окружения  
    
В рамках выполнения данного задания, для упрощения понимания, уложил все конфиги в три файла: фронтенд с сервисом, бекенд с сервисом и БД с сервисом.  
Ниже привожу тексты и картинку с выводами.  
  
[t2-frontend-svc.yaml:](https://github.com/alsxs/devops_dz/blob/main/devkub/13.1/t2-frontend-svc.yaml)  
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
  
[t2-backend-svc.yaml:](https://github.com/alsxs/devops_dz/blob/main/devkub/13.1/t2-backend-svc.yaml)  
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
        env:
          - name: DATABASE_URL
            value: postgres://postgres:postgres@t2-db:5432/news

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
  
[t2a-bd-ss-svc.yaml:](https://github.com/alsxs/devops_dz/blob/main/devkub/13.1/t2a-bd-ss-svc.yaml)  
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: t2-db
  namespace: prod
spec:
  selector:
    matchLabels:
      app: t2-db
  serviceName: "t2-db"
  replicas: 1
  template:
    metadata:
      labels:
        app: t2-db
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - image: postgres:13-alpine
        name: t2-db
        volumeMounts:
            - name: pgdata
              mountPath: /data/pgdata
        env:
          - name: POSTGRES_PASSWORD
            value: postgres
          - name: POSTGRES_USER
            value: postgres
          - name: POSTGRES_DB
            value: news
          - name: PGDATA
            value: /data/pgdata          
        ports:
        - containerPort: 5432
  volumeClaimTemplates:
  - apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: pgdata
    spec:
      accessModes: 
      - ReadWriteOnce
      storageClassName: ""
      resources:
        requests:
          storage: 1Gi
          
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pgdata
  namespace: prod  
spec:
  capacity:
    storage: 2Gi
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /data
                
---
apiVersion: v1
kind: Service
metadata:
  name: t2-db
  namespace: prod
  labels:
    app: t2-db
spec:
  type: ClusterIP
  selector:
    app: t2-db
  ports:
    - protocol: TCP
      port: 5432
      targetPort: 5432
```
  
Здесь, в рамках выполнения задания не до конца понял один момент: в темплейте pvc заказывался 1Gi, а выделилось 2. По какой причине это могло произойти? Одинаковое имя для pv и pvc?
  
![13.1_t2](https://github.com/alsxs/devops_dz/blob/main/devkub/13.1/13.1_t2a.png)
