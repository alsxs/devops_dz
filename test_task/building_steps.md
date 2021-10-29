## Описание последовательности сборки

Установка зависимостей и пакетов необходимых для сборки:
```shell
$ sudo apt-get install rpm-build rpm-build-python \
               python-devel python-module-setuptools python-module-lxml \
               jing libxslt libxml2-devel xsltproc
$ cd
$ mkdir tmp
$ cd ~/Загрузки
$ unzip distro-python2.6-support.zip -d ~/tmp
$ cd ~/tmp/distro-python2.6-support
$ python setup.py install # возможно потребуется переопределение прав на запись для ряда папок

```
  
  
Загрузка clufter:  

```shell
$ cd 
$ mkdir tmp
$ git clone https://github.com/jnpkrn/clufter.git ~/tmp/clufter
 
```
  
  
Проверка, сборка:
```shell
$ cd 
$ mkdir rpmbuild
$ cd rpmbuild
$ mkdir BUILD
$ mkdir RPMS
$ mkdir SOURCES
$ mkdir tmp
$ cd ~/tmp/clufter/__root__
$ ./run-check
$ ./run-tests
$ ./run-sdist
$ cp ~/tmp/clufter/__root__/dist/clufter-0.77.3a0.tar.gz ~/rpmbuild/SOURCES/clufter-0.77.3a0.tar.gz
$ python setup.py bdist_rpm
```
    
В случае появления ошибки верификации ELF, в spec-файл в раздел **%install** необходимо добавить   
строку **%set_verify_elf_method skip**  
  
Сформированный пакет *clufter-0.77.3a0-1.noarch.rpm* будет находиться в директории *~/rpmbuild/RPMS/noarch/*. 


