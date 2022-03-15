Build:
```sh
docker build . -t llvm-rv64gcv --cpuset-cpus="0,1,2,3,4,5,6,7"
```

Run:
```sh
docker run -u $UID:$GID --volume $PWD:/workdir -w /workdir --rm -it llvm-rv64gcv
```

Usage, e.g.,
```sh
clang vector-test.cpp -menable-experimental-extensions -march=rv64gcv -target riscv64-gnu-linux -O2 -mllvm --riscv-v-vector-bits-min=1024 -v --static -o vector-test
```
