# Docker Example

## Usage

Build the docker image:

```docker build --build-arg="VERSION=24.04" -t product-ubuntu24.04 .```

Run the docker container (a volume isn't needed but is required for the product to output content):

```docker run --rm -v /local/path/to/file1.txt:/container/path/to/file1.txt product-ubuntu24.04 /container/path/to/file1.txt```

