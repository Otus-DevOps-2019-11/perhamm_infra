# Выполнено ДЗ №6 (Знакомство с Terraform)

 - [ ] main task - С помощью терраформ развернуть VM из ранее собранного образа reddit-base. Выполнить следующие условия: есть input переменная для приватного ключа, есть input переменная для задания зоны в ресурсе"google_compute_instance", есть terraform.tfvars.example.
 - [ ] additional tasks (*) - В коде терраформа добавить ssh ключи для нескольких пользователей в метаданные проекта.
 - [ ] additional tasks (**) - В коде терраформа добавить балансировщик с проверкой бэкэндов, количество бэкендов должно задаваться через переменную count.

## В процессе сделано:
 - Для выполнения основного здания описан код в main.tf, добавлены описания переменных в variables.tf, terraform.tfvars заданы значения переменных, добавлен вывод в outputs.tf
 - Для выполнения задания со * добавлен следующий кусок кода в main.tf, определены и заданы соответствующие перменные
```
// Adding SSH Public Key in Project Meta Data
resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path1)} \nappuser2:${file(var.public_key_path2)} \nappuser3:${file(var.public_key_path3)}"
}
```
В результате ключи добавляются в метаданные проекта. При добавлении ключей через веб-интерфейс, при повторном применении кода терраформ, все, что было добавлено через web - сотрется
 - Для выполнения задания с ** частично пришлось переписать main.tf для поддержки count, а также в lb.tf добавлены: внешний ip, группа инстансов google_compute_instance_group (```instances = [for i in google_compute_instance.app.*.self_link : i]```), google_compute_health_check, google_compute_backend_service, url_map и google_compute_target_http_proxy с google_compute_global_forwarding_rule. В результате получаем простой http балансировщик. Отключение сервисов на одной из vm не приводит к остановке сервиса. Само приложение доступно по 80 порту на адресе балансировщика. Немного скриншотов:
![Image 1](https://github.com/Otus-DevOps-2019-11/perhamm_infra/blob/terraform-1/screenshots/terraform1/1.PNG)
![Image 2](https://github.com/Otus-DevOps-2019-11/perhamm_infra/blob/terraform-1/screenshots/terraform1/2.PNG)
![Image 3](https://github.com/Otus-DevOps-2019-11/perhamm_infra/blob/terraform-1/screenshots/terraform1/3.PNG)
![Image 4](https://github.com/Otus-DevOps-2019-11/perhamm_infra/blob/terraform-1/screenshots/terraform1/4.PNG)
![Image 5](https://github.com/Otus-DevOps-2019-11/perhamm_infra/blob/terraform-1/screenshots/terraform1/5.PNG)
![Image 6](https://github.com/Otus-DevOps-2019-11/perhamm_infra/blob/terraform-1/screenshots/terraform1/6.PNG)
![Image 7](https://github.com/Otus-DevOps-2019-11/perhamm_infra/blob/terraform-1/screenshots/terraform1/7.PNG)
<br>
## Как запустить проект:
 - Запуск не требуется

## Как проверить работоспособность:
 - В канале #anton_voskresenskij присутствуют сообщения о успешных билдах

## PR checklist
 - [ ] Pull request Label set to terraform and terraform-1
<br>

---
---
---
---
---

<details>
<summary>ДЗ №2 (Локальное окружение инженера. ChatOps и визуализация рабочих процессов. Командная работа с Git. Работа в GitHub.):</summary>
<p align="justify">

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
</p>
</details>

<details>
<summary>ДЗ №3 (Знакомство с облачной инфраструктурой и облачными сервисами.):</summary>
<p align="justify">

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
<br>

</p>
</details>



<details>
<summary>ДЗ №4 (Основные сервисы Google Cloud Platform (GCP)):</summary>
<p align="justify">

# Выполнено ДЗ №4

 - [ ] main task - Задеплоить тестовое приложение,запустить и проверить его работу.
 - [ ] additional tasks - Написать скрипты deploy.sh, install_mongodb.sh и install_ruby.sh. Написать startup script который будет запускаться при создании инстанса и полностью деплоить и запускать приложение. Добавить правило файрвола через gcloud.

## В процессе сделано:
 - Коммандой
```
gcloud compute firewall-rules create default-puma-server  --allow tcp:9292 --target-tags=puma-server --source-ranges=0.0.0.0/0
```
добавил правило файрволла для нашего тестовго приложения.
 - Коммандой
```
gcloud compute instances create reddit-app  --boot-disk-size=10GB   --image-family ubuntu-1604-lts   --image-project=ubuntu-os-cloud   --machine-type=g1-small   --tags puma-server   --restart-on-failure  --metadata-from-file startup-script=startupscript.sh
```
создал тестовую машину с автоматически выполняемым скриптом startupscript.sh после создания. Скрипт постарался сделать идемпотентным ( повторное применение не должно повторять всех действий :) )

Получились следующие данные для проверки:

```
testapp_IP = 35.246.237.88
testapp_port = 9292
```
 - Просто добавил deploy.sh, install_mongodb.sh и install_ruby.sh.

## Как запустить проект:
 - Запуск не требуется

## Как проверить работоспособность:
 - В канале #anton_voskresenskij присутствуют сообщения о успешных билдах

## PR checklist
 - [ ] Pull request Label set to GCP and cloud-testapp
<br>

</p>
</details>


<details>
<summary>ДЗ №5 (Знакомство с облачной инфраструктурой и облачными сервисами.):</summary>
<p align="justify">

# Выполнено ДЗ №5

 - [ ] main task - Создать и параметризировать с некоторыми обязательными параметрами шаблон Packer для создания образа VM с предустановленными ruby и mongodb.
 - [ ] additional tasks (*) - Создать bake образ VM при разворачивании которого на выходе получается сразу рабочее приложение.
 - [ ] additional tasks (*) - Сделать запуск VM через gcloud.

## В процессе сделано:
 - Сделан шаблон ubuntu16.json с указанием, что переменные ```project_id``` и  ```source_image``` являются обязательными. Переменные задаются в файлике variables.json. Также в шаблоне указаны скрипты, проводящие установку ruby и mongodb. Собран образ коммандой
```
packer build -var-file=variables.json ubuntu16.json
```
В результате получился образ reddit-base-1577267109
 - Для выполнения задания со * Сделан скрипт setupscript.sh и шаблон immutable.json. Скрипт setupscript.sh устанваливает ruby , mongodb и инсталирует приложение, а также добавляет systemd unit для приложения. Образ собирается коммандой
```
packer build -var-file=variables.json immutable.json
```
В результате получился образ reddit-full-1577267660
 - Добавил комманду запуска приложения с помощью gcloud в create-reddit-vm.sh
```
gcloud compute instances create reddit-app --zone=europe-west3-a --machine-type=f1-micro --tags=puma-server --image=reddit-full-1577267660 --image-project=infra-262405 --restart-on-failure
```

## Как запустить проект:
 - Запуск не требуется

## Как проверить работоспособность:
 - В канале #anton_voskresenskij присутствуют сообщения о успешных билдах

## PR checklist
 - [ ] Pull request Label set to packer-base and Packer
<br>


<br>

</p>
</details>
