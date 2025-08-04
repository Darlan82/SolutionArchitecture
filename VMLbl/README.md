### Ajuste no `provider.tf`
* Altere o `tenant_id` no arquivo [`provider.tf`](Infra/provider.tf) conforme necessário.

### Comandos:
Instruções realizadas no Windows 11.<br>
Execute todos os passos na pasta [`Infra`](Infra/).<br>

Gerar uma chave SSH:
```bash
ssh-keygen -t rsa -b 2048 -f id_rsa
```

Realizar login na Azure:
```bash
az login --tenant <tenant_id>
```

Inicializar e planejar o Terraform:
```bash
terraform init
terraform plan
```

Criar apenas a VM1:
```bash
terraform apply -target='module.vm'
```

Conectar via SSH na VM:
```bash
ssh -i id_rsa azureuser@<IP_PUBLICO>
```

Instalar o PHP:
```bash
sudo su
sudo apt update
sudo apt install -y php
```

Saia e volte ao terminal.<br>
Copie o arquivo `index.php` para a home do usuário:
```bash
scp -i id_rsa ..\src\index.php azureuser@<IP_PUBLICO>:/home/azureuser/index.php
```

Conecte novamente via SSH:
```bash
ssh -i id_rsa azureuser@<IP_PUBLICO>
```

Substitua a página padrão do servidor web:
```bash
sudo mv /home/azureuser/index.php /var/www/html/index.php
sudo rm /var/www/html/index.html
```

Remova as configurações de usuário:
```bash
sudo su
sudo waagent -deprovision+user
```

Saia e volte ao terminal.<br>
Pare a VM1 (use a linha de comando ou o portal Azure).<br>
Criar o snapshot da VM1:
```bash
terraform apply -target='module.vm-snapshot'
```

Criar o Load Balancer e o VMSS:
```bash
terraform apply -target='module.vmss'
```