You can move filesystem trees around between mount namespaces
very simply with the new "mount as file descriptor" calls in
modern Linux kernels.

run as
```
docker run -p localhost:8080:8080 --privileged --pid=host -v /var/run/docker.sock:/var/run/docker.sock nicks/addmount
curl "http://localhost:8080/addmount?src=/tmp&src-proc=src-container&dest=/tmp&dest-proc=dest-container"
```

where `src-container` and `dest-container` are container names or process IDs.
Replace the paths with any paths you like. 

The src path must be a directory and the destination path must be an empty
directory.

The C code is very simple: `open_tree` is equivalent to `mount --bind` and
`move_mount` will move the mount corresponding to the file descriptor. Use
file descriptors for everything!

Based on https://github.com/justincormack/addmount, but exposed over HTTP.
