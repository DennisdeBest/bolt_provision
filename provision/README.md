## Installation

### Mise en place du provisionning
	
	cd [project]
	git clone git@g.avril.co:ansible/provisioning.git provision

### Configuration vagrant dev

``` ruby
config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provision/playbook.yml"
    ansible.inventory_path = "provision/hosts"
    ansible.limit = "dev" # Groupe de host
end
```

### Configuration des groupe de provisionning

Dans le fichier `provision/hosts` ajouter l'ip de votre vm vagrant dans le groupe dev :

```
[dev]
10.0.0.xxx # ip de la vagrant
```

Pour trouver l'ip de la vm vagrant trouver la ligne ci-dessous dans le Vagrantfile :

``` ruby
config.vm.network "private_network", ip: "10.0.0.50"
```
### Configuration du playbook

Le playbook est la recette de cuisine que va suivre ansible pour installer votre vm. 

``` yaml
---

- name: Le nom que tu veux pour ton super projet
  hosts: dev # Limit l'installation sur un groupe
  remote_user: vagrant # force l'utilisation de l'utilisateur vagrant

  # Défini les role(recette de cuisine) qui vont être appliqués
  roles:
    - mysql
    - php5
    - nginx
    - redis
    - common
...

```

## Mise en place / modification pour un projet

### Création d'une branche dédiée

	# checkout or create branch for your project
	git checkout -b project/[projectname]
	# create playbook.yml from .dist for your project
	mv playbook.yml.dist playbook.yml

Faire les modifications du playbook.yml et du fichier host puis :

	git push -u origin project/[projectname]

### Lancement du provisionning sur la vm vagrant
	
	vagrant up

	vagrant provision

