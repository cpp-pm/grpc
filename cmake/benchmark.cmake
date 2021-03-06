# Copyright 2017 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if(gRPC_BENCHMARK_PROVIDER STREQUAL "module")
  set(BENCHMARK_ENABLE_GTEST_TESTS OFF CACHE BOOL "Turn off gTest in gBenchmark")
  if(NOT BENCHMARK_ROOT_DIR)
    set(BENCHMARK_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/benchmark)
  endif()
  if(EXISTS "${BENCHMARK_ROOT_DIR}/CMakeLists.txt")
    add_subdirectory(${BENCHMARK_ROOT_DIR} third_party/benchmark)
    if(TARGET benchmark)
      set(_gRPC_BENCHMARK_LIBRARIES benchmark)
    endif()
  else()
    message(WARNING "gRPC_BENCHMARK_PROVIDER is \"module\" but BENCHMARK_ROOT_DIR is wrong")
  endif()
elseif(gRPC_BENCHMARK_PROVIDER STREQUAL "package")
  # Use "CONFIG" as there is no built-in cmake module for benchmark.
  hunter_add_package(benchmark)
  find_package(benchmark REQUIRED CONFIG)
  if(TARGET benchmark::benchmark)
    set(_gRPC_BENCHMARK_LIBRARIES benchmark::benchmark)
  endif()
  set(_gRPC_FIND_BENCHMARK "if(NOT benchmark_FOUND)\n  find_package(benchmark CONFIG)\nendif()")
elseif(gRPC_BENCHMARK_PROVIDER STREQUAL "none")
  # Benchmark is a test-only dependency and can be avoided if we're not building tests.
endif()
