# btstrp

Using ansible to quickly and constantly configure Unix desktops for development.

## Usage

- `chmod +x install.sh && ./install.sh`
- `ansible-playbook playbooks/main.yml -K -e "hostname=$HOSTNAME github_access_token=$GITHUB_ACCESS_TOKEN"`


