# devspace-sync-poc

To reproduce:
* Change `dockerregistry.example.com` to whatever docker registry you have access to
* run `devspace dev` for the first time:
```
$ devspace dev
[info]   Using kube context 'devspace-roel'
[info]   Using namespace 'roel'
[info]   Building image 'dockerregistry.example.com/rh-devspace-sync-poc:dev-roelharbers-MAH9t4' with engine 'docker'
[done] √ Authentication successful (dockerregistry.example.com)
[warn]   Using CMD statement for injecting restart helper because ENTRYPOINT is missing in Dockerfile and `images.*.entrypoint` is also not configured
Sending build context to Docker daemon  102.1kB
Step 1/9 : FROM alpine:3.12
 ---> a24bb4013296
Step 2/9 : WORKDIR /foo
 ---> c08554530958
Step 3/9 : COPY foo/bar .
 ---> aafce6f40e24
Step 4/9 : RUN ls -la
 ---> Running in 76f532bf4f80
total 12
drwxr-xr-x    1 root     root          4096 Sep 17 11:05 .
drwxr-xr-x    1 root     root          4096 Sep 17 11:05 ..
-rw-rw-r--    1 root     root             7 Sep 17 11:02 bar
 ---> 32e80d690604
Step 5/9 : RUN md5sum *
 ---> Running in c5d411678ba2
14758f1afd44c09b7992073ccf00b43d  bar
 ---> 37cd7146ff1e
(...)
[done] √ Successfully deployed dev with kubectl
[done] √ Sync started on /home/roel/git/devspace-sync-poc/foo <-> /foo (Pod: roel/rh-devspace-sync-poc-7f6bd8498c-t4q8x)
(...)
[rh-devspace-sync-poc-7f6bd8498c-t4q8x] ****
[rh-devspace-sync-poc-7f6bd8498c-t4q8x] total 12
[rh-devspace-sync-poc-7f6bd8498c-t4q8x] drwxr-xr-x    1 root     root          4096 Sep 17 11:05 .
[rh-devspace-sync-poc-7f6bd8498c-t4q8x] drwxr-xr-x    1 root     root          4096 Sep 17 11:05 ..
[rh-devspace-sync-poc-7f6bd8498c-t4q8x] -rw-rw-r--    1 root     root             7 Sep 17 11:02 bar
[rh-devspace-sync-poc-7f6bd8498c-t4q8x] 14758f1afd44c09b7992073ccf00b43d  bar
[rh-devspace-sync-poc-7f6bd8498c-t4q8x] foobar
```
* Ctrl-C to stop `devspace dev`
* change only the modification date of a file:
```
$ touch foo/bar
```
* start `devspace dev` again:
```
$ devspace dev
(...)
Step 3/9 : COPY foo/bar .
 ---> Using cache
 ---> aafce6f40e24
(..)
[done] √ Successfully deployed dev with kubectl
[done] √ Sync started on /home/roel/git/devspace-sync-poc/foo <-> /foo (Pod: roel/rh-devspace-sync-poc-5955577f4f-mgstd)
(...)
[rh-devspace-sync-poc-5955577f4f-mgstd] ****
[rh-devspace-sync-poc-5955577f4f-mgstd] total 12
[rh-devspace-sync-poc-5955577f4f-mgstd] drwxr-xr-x    1 root     root          4096 Sep 17 11:05 .
[rh-devspace-sync-poc-5955577f4f-mgstd] drwxr-xr-x    1 root     root          4096 Sep 17 11:08 ..
[rh-devspace-sync-poc-5955577f4f-mgstd] -rw-rw-r--    1 root     root             7 Sep 17 11:02 bar
[rh-devspace-sync-poc-5955577f4f-mgstd] 14758f1afd44c09b7992073ccf00b43d  bar
[rh-devspace-sync-poc-5955577f4f-mgstd] foobar
(...)
[rh-devspace-sync-poc-5955577f4f-mgstd] ############### Restart container ###############
[rh-devspace-sync-poc-5955577f4f-mgstd]
[rh-devspace-sync-poc-5955577f4f-mgstd] ****
[rh-devspace-sync-poc-5955577f4f-mgstd] total 16
[rh-devspace-sync-poc-5955577f4f-mgstd] drwxr-xr-x    1 root     root          4096 Sep 17 11:05 .
[rh-devspace-sync-poc-5955577f4f-mgstd] drwxr-xr-x    1 root     root          4096 Sep 17 11:08 ..
[rh-devspace-sync-poc-5955577f4f-mgstd] -rw-rw-r--    1 root     root             7 Sep 17 11:07 bar
[rh-devspace-sync-poc-5955577f4f-mgstd] 14758f1afd44c09b7992073ccf00b43d  bar
[rh-devspace-sync-poc-5955577f4f-mgstd] foobar
```

The container restarted, right after startup, without any changes to the actual files.

Note the `7 Sep 17 11:02` (from the image) before the restart, and the `7 Sep 17 11:07` (from the `touch`) after the restart.
