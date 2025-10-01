function dbuild -d "Builds a Docker image using the current directory name as the image name."
    set -l img_name (basename (pwd))
    echo "Building Docker image: $img_name"
    docker build -t "$img_name" .
end

function dtest -d "Runs a Docker container with a random name, and delete it at exit."
    set -l rand_id (shuf -i 1-100 -n 1)
    set -l img_name (basename (pwd))
    set -l rand_name "$img_name-$rand_id"
    set -l name "$rand_name"

    echo "Running Docker container: $name from image: $img_name"
    docker run -it --rm \
        --add-host host.docker.internal:host-gateway \
        --name "$name" \
        --hostname "$name" \
        -v (pwd)/mnt/:/mnt \
        "$img_name"
end

function drun -d "Runs a Docker container with a random name."
    set -l rand_id (shuf -i 1-100 -n 1)
    set -l img_name (basename (pwd))
    set -l rand_name "$img_name-$rand_id"
    set -l name "$rand_name"

    echo "Running Docker container: $name from image: $img_name"
    docker run -it --add-host host.docker.internal:host-gateway --name "$name" --hostname "$name" "$img_name"
end

function dshell -d "Gets a shell in a running Docker container."
    # List running Docker containers to help the user choose
    echo "Running Docker containers:"
    docker ps --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"

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
    docker exec -it "$container_id_or_name" fish || docker exec -it "$container_id_or_name" bash || docker exec -it "$container_id_or_name" sh || echo "Could not find a shell (bash or sh) in container $container_id_or_name. You might need to specify the command manually, e.g., 'docker exec -it CONTAINER_ID your_command'."
end
