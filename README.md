# Whanos

Whanos is a powerful infrastructure that allows developers to automatically deploy an application into a cluster, just by pushing it to their Git repository. It uses four DevOps technologies: Docker, Kubernetes, Jenkins, and Ansible.

## 🚀 Installation

### Requirements :

- ansible-playbook

### Install

- Clone the repository
- Create your hosts.yml

Example :
```all:
  hosts:
    whanos:
      ansible_connection: local
    master:
      ansible_host: 127.0.0.1
      ansible_user: root
      ansible_connection: ssh
      ansible_ssh_pass: ****
```

- Execute `ansible-playbook ansible/playbooks/whanos-deployment.yml -i ansible/hosts.yml`


## 🕹️ Usage

To use Whanos, the repository must contain a single application written in one of the following supported languages: C, Java, JavaScript, Python, or Befunge. The source code and resources must be in an app directory placed at the root of the repository.

Whanos will perform the following steps after a push to a compatible repository:

- Fetches the Git repository.
- Analyses its content to determine its technology.
- Containerizes the application into an image based on both a Whanos image and an eventual user-provided image customization.
- Pushes the image into a Docker registry.
- If a valid whanos.yml file exists, deploys the image into a cluster following the given configuration.

## ✍️ Repository structure

The following structure is required for a repository to be compatible with the Whanos infrastructure:

```.
└── app/
    ├── src/
    └── Compile files (e.g., Makefile, pom.xml, package.json, requirements.txt, main.bf)
```