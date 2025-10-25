function pod-build -d "Builds a Podman image using the current directory name as the image name."
    set -l img_name (basename (pwd))
    echo "Building Podman image: $img_name"
    podman build -t "$img_name" .
end

function pod-test -d "Runs a Podman container with a random name, and delete it at exit. Use --network to enable a separate network."
    argparse --name pod-test 'n/network' -- $argv
    set -l rand_id (shuf -i 1-100 -n 1)
    set -l img_name (basename (pwd))
    set -l rand_name "$img_name-$rand_id"
    set -l name "$rand_name"
    set -l network "$img_name-net"
    if set -q _flag_network
        podman network create "$network" # 2>/dev/null
    end
    echo "Running Podman container: $name from image: $img_name"
    set -l run_cmd podman run -it --rm \
        --add-host host.docker.internal:host-gateway \
        --name "$name" \
        --hostname "$name" \
        -v (pwd)/mnt/:/mnt
    if set -q _flag_network
        set run_cmd $run_cmd --network "$network"
    end
    set run_cmd $run_cmd "$img_name"
    $run_cmd
    if set -q _flag_network
        podman network rm "$network" 2>/dev/null
    end
end

function pod-run -d "Runs a Podman container with a random name."
    set -l rand_id (shuf -i 1-100 -n 1)
    set -l img_name (basename (pwd))
    set -l rand_name "$img_name-$rand_id"
    set -l name "$rand_name"

    echo "Running Podman container: $name from image: $img_name"
    podman run -it --add-host host.docker.internal:host-gateway --name "$name" --hostname "$name" "$img_name"
end

function pod-shell -d "Gets a shell in a running Podman container."
    # List running containers to help the user choose
    echo "Running Podman containers:"
    podman ps --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"

    echo "" # Empty line for better readability

    # Prompt the user to enter the target container's ID or Name
    read -P "Enter container ID or Name to get a shell into: " container_id_or_name

    # Check if the user input is empty
    if test -z "$container_id_or_name"
        echo "No container ID or Name provided. Exiting."
        return 1 # Exit the function with an error code
    end

    # Attempt to execute a shell (bash, then sh) in the specified container
    # The -it options are crucial for an interactive shell with a pseudo-terminal
    echo "Attempting to get a shell into $container_id_or_name..."
    podman exec -it "$container_id_or_name" fish || podman exec -it "$container_id_or_name" bash || podman exec -it "$container_id_or_name" sh || echo "Could not find a shell (bash or sh) in container $container_id_or_name. You might need to specify the command manually, e.g., 'podman exec -it CONTAINER_ID your_command'."
end
