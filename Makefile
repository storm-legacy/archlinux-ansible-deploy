-include .env.example
-include .env

PYTHON := python3
VENV := .venv
BIN := $(VENV)/bin

ifeq ($(OS), Windows_NT)
  BIN = $(VENV)/Scripts
  PYTHON = python
endif

TARGET_PLAYBOOK := install.yml

init: venv install
	$(PYTHON) ./console.py copy -s ".env.example" -d ".env"
	$(PYTHON) ./console.py copy -s "vault.example.yml" -d "vault.yml"
	$(BIN)/ansible-vault encrypt "vault.yml"

dev:
	ANSIBLE_HOST_KEY_CHECKING=False \
	$(BIN)/ansible-playbook $(TARGET_PLAYBOOK) \
		-vv \
		-c ssh \
		-i $(SSH_HOST), \
		-e "ansible_connection=ssh ansible_ssh_user=$(SSH_USER) ansible_ssh_pass=$(SSH_PASS) ansible_ssh_port=$(SSH_PORT) ansible_become_pass=$(SSH_PASS)"