Bootstrapping development environment
-------------------------------------

1. Install Vagrant.
2. cd Ansible/ && vagrant up
3. Install Ansible.
4. Run this: `ansible-playbook -i development playbook.yml -u vagrant --private-key=~/.vagrant.d/insecure_private_key -vvv`
5. If step 4 failed, run it again.

# TODO: remaining steps: deployment with Capistrano.
