# docker_build_caspar_Ub22
Dockerfile to compile CasparCG server for Ubuntu 22.04
### How to use
You need to have docker installed on your device (https://docs.docker.com/engine/install/ubuntu/)
1. download Dockerfile into an empty directory for CasparCG server
2. `docker build . -t caspar-ub2204`
3. `docker run --name caspar-ub2204 -it caspar-ub2204 /bin/bash`
4. Open another terminal window (Ctrl+Shift+N)
5. `docker cp caspar-ub2204:/opt/build/server/staging/ .`
6. You now have executable CasparCG in staging subfolder
7. You can now exit the docker container in the original terminal window (`exit`)
8. Depending on your environment you might be missing several packages which could be installed using `sudo apt install packagename` packages known to be missing for some include:
    - libtbb12
    - libsfml-graphics2.5
    - libglew2.2
    - libfreeimage3
