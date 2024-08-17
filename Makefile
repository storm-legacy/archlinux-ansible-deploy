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

.PHONY: default
default: run

init: venv install dotenv

venv:
	$(PYTHON) -m venv $(VENV)

install:
	$(BIN)/pip install -r requirements.txt

dotenv:
	$(PYTHON) -c 'import os,shutil; shutil.copy(".env.example",".env") if not os.path.exists(".env") else None'

run:
	# TODO

dev:
	ANSIBLE_HOST_KEY_CHECKING=False \
	$(BIN)/ansible-playbook $(TARGET_PLAYBOOK) \
		-vv \
		-c ssh \
		-i $(SSH_HOST), \
		-e "ansible_connection=ssh ansible_ssh_user=$(SSH_USER) ansible_ssh_pass=$(SSH_PASS) ansible_ssh_port=$(SSH_PORT) ansible_become_pass=$(SSH_PASS)"