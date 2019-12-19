# Выполнено ДЗ №2

 - [ ] main task

## В процессе сделано:
 - Добавлен хук pre-commit
 - Добавлен шаблон для последующих PR в GitHub
 - Репозиторий подключен к тестам в Travis

## Как запустить проект:
 - Запуск не требуется

## Как проверить работоспособность:
 - В канале #anton_voskresenskij присутствуют сообщения о успешных билдах

## PR checklist
 - [ ] Pull request Label set to play-travis

<br>

# Выполнено ДЗ №3

 - [ ] main task - подключение через бастион хост, добавление setupvpn.sh и cloud-bastion.ovpn в ветку cloud-bastion, в README.md указать ip
 - [ ] additional tasks - предложить решения по подключению к внутренней машине через бастион-хост в 1 строчку, предложить решения для подклчюения по алиасу, добавить сертификат Let's Encrypt

## В процессе сделано:
 - Создал виртуальные машины bastion и someinternalhost в регионе europe-west3-c. Получившиеся ip
```
bastion_IP = 35.207.115.233
someinternalhost_IP = 10.156.0.3
```
 - Установлен и настроен VPN-сервер Pritunl
 - По поводу подключения в одну строчку с рабочей машины - делаем вот так (предварительно нужно выполнить ```ssh-add ~/.ssh/appuser```):
 ```
 ssh -i ~/.ssh/appuser -t -A appuser@35.207.115.233 ssh 10.156.0.3
 ```
 - Вариант для подключения в виде ```ssh someinternalhost``` - делаем файлик .ssh/config со следующим содержимым:
 ```
 fyvaoldg@fyvaoldg-ProLiant-BL460c-Gen9:~$ cat .ssh/config 
Host someinternalhost
        HostName 35.207.115.233
        Port 22
        User appuser
        IdentityFile /home/fyvaoldg/.ssh/appuser
        RequestTTY force
        RemoteCommand ssh 10.156.0.3
        ForwardAgent yes
 ```
 После чего становится возможным подключение напрямую коммандой ```ssh someinternalhost```
 
 - Добавил сертификат автоматически через кнопку Settings в панели управления Pritunl, указав адрес 35-207-115-233.sslip.io
 - Добавил ветку cloud-bastion и требуемые файлики соглсно методичке

## Как запустить проект:
 - Запуск не требуется

## Как проверить работоспособность:
 - В канале #anton_voskresenskij присутствуют сообщения о успешных билдах

## PR checklist
 - [ ] Pull request Label set to cloud-bastion
