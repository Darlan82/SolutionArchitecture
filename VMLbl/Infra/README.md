### Ajustes no `provider.tf`.
* Trocar  o tenant_id

### Comandos:
Execute os passos na pasta Infra.<br>
Instruções feitas no Windows 11<br>

Gera a chave de SSH antes. 
```bash 
ssh-keygen -t rsa -b 2048 -f id_rsa
```
Login Azure
```bash
az login --tenant <tenant_id>
```

Criar Ambiente
```bash
terraform init
terraform plan
```

Criar a Somente a VM1
```bash
 terraform apply -target='module.vm'
```

Conectar via SSH
```bash
ssh -i id_rsa azureuser@<IP_PUBLICO>
```

Instalar o PHP
```bash
sudo su
sudo apt update
sudo apt install -y php
```

Saia e volte ao terminal <br>
Copie a index.php para home
```bash
scp -i id_rsa ..\src\index.php azureuser@<IP_PUBLICO>:/home/azureuser/index.php
```

Conectar via SSH
```bash
ssh -i id_rsa azureuser@<IP_PUBLICO>
```

Substitua a página default
```bash
sudo mv /home/azureuser/index.php /var/www/html/index.php
sudo rm /var/www/html/index.html
```

Remova as configurações de usuário
```bash
sudo su
sudo waagent -deprovision+user
```

Saia e volte ao terminal <br>
Pare a VM1 <br>
Criar o snapshot da VM1
```bash
 terraform apply -target='module.vm-snapshot'
```

Criar o  Load Balancer e VMSS
```bash
 terraform apply -target='module.vmss'
```