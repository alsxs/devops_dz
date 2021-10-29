# Инструкция по установке

## Зависимости

- Дистрибутив ALT Linux 7.0.5 SPT;  
- Пакет 'distro'. Страница пакета:  [distro](https://github.com/python-distro/distro/tree/python2.6-support).  

## Установка

Ниже приведен типовой перечень команд для установки clufter. Предполагается, что указанный в зависимостях дистрибутив установлен, пакеты clufter-0.77.3a0-1.noarch.rpm и distro-python2.6-support.zip загружены и находятся в дирректории ~/Загрузки.  

```shell
$ cd
$ mkdir tmp
$ cd ~/Загрузки
$ unzip distro-python2.6-support.zip -d ~/tmp
$ cd ~/tmp/distro-python2.6-support
$ python setup.py install # возможно потребуется переопределение прав на запись для ряда папок

$ cd ~/Загрузки
$ sudo rpm -ivh clufter-0.77.3a0-1.noarch.rpm 
```

