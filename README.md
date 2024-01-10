# dev-container
My personal docker container for rust dev

# How to install / use
## To build the image *(from source)*

1. install docker (if you haven't already)
2. *(for linux)* run `./build.sh`
  - or *(for non-linux)* run `docker build -t gc-dev .`

## To run the image
1. *(for linux)* run `./run.sh /path/to/your/project`

  - or *(for non-linux)* run `docker run -it --rm -v /path/to/your/project:/home/greenchild/project gc-dev`
