# Exposing a Remote PostgreSQL Database running in lxd container

This document outlines the steps for establishing a secure connection to a PostgreSQL database running within an LXD container. This approach utilizes SSH port forwarding to create a tunnel between your local machine and the container.

## Prerequisites:

- We are assumming your setup used dhis2-server-tools, with default container network of 172.19.2.0/24
- Knowledge of your host machine's public IP address. You can find this by searching "what is my ip" on a web browser.
Knowledge of your host machine's SSH port (default is 22). Check your server configuration if unsure.
- Ability to connect to the host machine via SSH with appropriate credentials.
- A PostgreSQL client application installed on your local machine.
- Ensure you lxd container allow access from 172.19.2.1 (the host)

## Steps:

1. Identify Local Port: Choose a non-conflicting port number on your local machine to act as the forwarding destination. It's recommended to use ports above 1024. Let's use 5433 as an example.

2. Establish SSH Tunnel: Open a terminal window and execute the following command, replacing the placeholders with your specific information:
```
ssh -p <host_ssh_port> <user>@<host_public_ip> -L localhost:<local_port>:172.19.2.20:5432
```
  **Explanation of the Command:**
    - `ssh`: Initiates an SSH connection to the host machine.
    - -p <host_ssh_port> (optional): Specifies the SSH port of your host machine if it differs from the default 22.
    - `<user>`: Your username for logging into the host machine.
    - `@<host_public_ip>`: The public IP address of your host machine.
    - `-L localhost:<local_port>:172.19.2.20:5432`: This creates the SSH tunnel:
        - `localhost`: Specifies the connection is forwarded to your local machine.
        - `<local_port>`: The chosen port on your machine (e.g., 5433).
        - `172.19.2.20`: The IP address of the LXD container hosting the PostgreSQL server.
        - `5432`: The port number of the PostgreSQL server within the container.

3. Connect to PostgreSQL: Once the SSH connection is established, you can connect to your PostgreSQL server using your chosen local port (e.g., localhost:5433) and your PostgreSQL client application.

## Security Considerations:
This approach establishes a tunnel for the duration of the SSH session. Closing the terminal window will terminate the connection.
