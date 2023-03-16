# gcc-rv64gcv
This image contains the built riscv-gnu-toolchain with the rvv-next branch checked out.
The gcc compilers should be able to compile binaries with RISC-V vector instructions.

## Build

```sh
docker build -f gcc-rv64gcv -t org/gcc-rv64gcv .
```

## Bring up the container

```sh
docker run -u $UID:$GID --volume $PWD:/workdir -w /workdir --rm -it org/gcc-rv64gcv
```

## Compilation

```sh
riscv64-unknown-linux-gnu-g++ gather_load.cpp -O3 -march=rv64gcv
riscv64-unknown-linux-gnu-objdump -D a.out | grep -i "vluxei64.v"
```
