# Copyright (c) 2022-2023 The Regents of the University of California
# All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met: redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer;
# redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution;
# neither the name of the copyright holders nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y update
RUN apt -y upgrade
RUN apt -y install \
  binutils build-essential libtool texinfo gzip zip unzip patchutils curl git \
  make cmake ninja-build automake bison flex gperf grep sed gawk bc \
  zlib1g-dev libexpat1-dev libmpc-dev libglib2.0-dev libfdt-dev libpixman-1-dev

RUN mkdir -p /riscv/_install
WORKDIR /riscv
ENV PATH=`/riscv/_install/bin:$PATH`
RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain -j`nproc`
WORKDIR /riscv/riscv-gnu-toolchain
RUN ./configure --prefix=/riscv/_install --enable-multilib
RUN make linux -j`nproc`
RUN make install
WORKDIR /riscv
RUN git clone -b llvmorg-17.0.2 https://github.com/llvm/llvm-project.git riscv-llvm
WORKDIR /riscv/riscv-llvm
RUN mkdir _build
WORKDIR /riscv/riscv-llvm/_build
RUN cmake -G Ninja -DCMAKE_BUILD_TYPE="Release" \
  -DBUILD_SHARED_LIBS=True -DLLVM_USE_SPLIT_DWARF=True \
  -DCMAKE_INSTALL_PREFIX="/workdir/artifacts/riscv/_install" \
  -DLLVM_OPTIMIZED_TABLEGEN=True -DLLVM_BUILD_TESTS=False \
  -DDEFAULT_SYSROOT="/workdir/artifacts/riscv/_install/sysroot" \
  -DLLVM_DEFAULT_TARGET_TRIPLE="riscv64-unknown-linux-gnu" \
  -DLLVM_TARGETS_TO_BUILD="RISCV" \
  -DLLVM_ENABLE_PROJECTS="clang;flang;openmp;polly" \
  ../llvm
RUN cmake --build . --target install -j`nproc`

