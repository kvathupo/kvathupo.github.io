# Notes
* https://github.com/pytorch/pytorch/issues/89320
    * Left off:
```bash
vim -p aten/src/ATen/native/IndexKernel.h aten/src/ATen/native/cpu/IndexKernel.cpp  aten/src/ATen/native/quantized/IndexKernel.h aten/src/ATen/native/quantized/cpu/kernels/QuantizedOpKernels.cpp aten/src/ATen/native/quantized/TensorAdvancedIndexing.cpp  ./aten/src/ATen/native/cpu/IndexKernel.* aten/src/ATen/native/TensorAdvancedIndexing.cpp  ./aten/src/ATen/native/native_functions.yaml ./aten/src/ATen/native/README.md  ~/Witches_Cauldrin/pytorch/NOTES.md
```
        * Compile with std::cerr and TORCH_WARN prints to see what methods called
    * Earlier:
```bash
vim -p ./torch/_C/_VariableFunctions.pyi ./torch/_C/__init__.pyi ./torch/csrc/autograd/generated/python_torch_functions_0.cpp  ./torch/include/ATen/ops/masked_fill.h ./torch/include/ATen/ops/masked_fill_ops.h  ./torch/csrc/utils/python_arg_parser.* ./torch/include/ATen/core/Tensor.h ./torch/include/ATen/core/TensorBody.h ./torch/csrc/autograd/generated/VariableType_4.cpp
```
--- paper trail
    * Modify `torch/_refs/__init__.py`
        - Didn't seem to work: look at `torch/_tensor.py`
    * Python bindings defined in `./aten/src/ATen/native/native_functions.yaml`.
Explained here `./aten/src/ATen/native/README.md`
        * [Wiki article](https://github.com/pytorch/pytorch/wiki/Tensor-and-Operator-Basics)
    * All the `./torch/include/ATen/ops` are red herrings: auto-generated from python, e.g. not on github
    * In `native_functions.yaml`, there are four signatures: two for masking with scalars/tensors,
and two for in-place modification.
    * Documentation for `native_functions.yaml`:
```markdown
  - `CompositeExplicitAutograd` (previously known as `DefaultBackend`):
    implementations of kernels that work for all backends, but require an
    explicit definition of backward function in `derivatives.yaml` to support autograd.
    The most typical use of this key are for delegating functions; i.e.,
    functions that do a very small amount of work and then delegate to another
    operator to do the actual heavy lifting.  Under the hood, registering a
    kernel to `CompositeExplicitAutograd` is equivalent to registering that
    kernel to every backend (e.g., `CPU, CUDA`). Note: kernels which call
    DispatchStub should NOT be registered as CompositeExplicitAutograd, as
    DispatchStub only works for `CPU, CUDA`)
```

    * Replicate:
```python
>>> import torch
>>> x = torch.rand(4, 4)
>>> m = torch.rand(4, 4) > 0.5
>>> x_masked = x.masked_fill(m.float(), 0.)
```
    * Related issue from `/torch/overrides.py`:
```python
# Every function in the PyTorchAPI that can be overriden needs an entry
# in this dict.
#
# Optimally we would use inspect to get the function signature and define
# the lambda function procedurally but that is blocked by generating
# function signatures for native kernels that can be consumed by inspect.
# See Issue #28233.
```
* https://github.com/pytorch/pytorch/issues/90499
    * Fails at calculating the Jacobian of the mapping of linear transform to eigenvalues
    * Appears the linked problem code in the issue is only valid for a diagonalizable matrix
even though `eigvals` doesn't require it. Neither does the torch eigenvalue decomposition, which
is curious.
        * How does it react to a non-diagonalizable matrix?
    * "Problem" code:
    https://github.com/pytorch/pytorch/blob/dc40b6d04320baf26b940225a65f40466ebf3664/torch/csrc/autograd/FunctionsManual.cpp#L3552-L3565
    * `jacrev()` defined here:
    https://github.com/pytorch/pytorch/blob/master/torch/_functorch/eager_transforms.py
    * yml for derivatives (`linalg_eig` in this case):
    https://github.com/pytorch/pytorch/blob/51c6c5e156c64d84ff0cd06a559fa6786c96f128/tools/autograd/derivatives.yaml
        * Can't seem to find it, closest here (`apply_linalg_eig`):
        https://github.com/pytorch/pytorch/blob/94da90e41f171975cc455dcf42e80918d06d978b/aten/src/ATen/native/cuda/linalg/BatchLinearAlgebra.cpp
    * kk

* Keys can't have duplicates in an ordereddict (occurs when cloning => just add str(index))
    * Comment this fact with respect to the many `push_back` methods in Sequential
    * footguns from prev shared_ptr
    * `PrettyPrintSequential` passing proves adherence to existing behavior
    * Error occurs with `HasReferenceSemantics` => it _is_ from adding multiple of the same module to a `Sequential`
    * `push_back()` originally used the `modules_.size()` label in order to accomadate parameter expansion in the case of 1 parameter in
variadic template constructor.
    * Passing `size_t` avoids ambiguity with public facing push_back

* Compile:
```bash
MAX_JOBS=2 DEBUG=1 USE_KINETO=0 USE_ITT=0 USE_DISTRIBUTED=0 USE_MKLDNN=0 USE_CUDA=0 python3 setup.py develop
MAX_JOBS=2 DEBUG=1 USE_KINETO=0 USE_ITT=0 USE_DISTRIBUTED=0 USE_MKLDNN=0 USE_CUDA=1 python3 setup.py develop
```
## Current
https://github.com/pytorch/pytorch/issues/90500

    -> see: https://github.com/pytorch/pytorch/blob/master/torch/csrc/README.md
```bash
vim -p __init__.py variable.py -p ../_six.py ../_C/__init__.pyi ../csrc/autograd/python_legacy_variable.cpp ../csrc/autograd/python_engine.cpp ../csrc/utils/object_ptr.h
```
    * We effectively lose the named by narrowing our type to AnyModule, instead of NamedAnyModule
    * Did Cloneable clone names? Check without commit.
    * Get name from `AnyModulePlaceholder`  =>  it's an abstract class! Clarify in the comment!     =>      Seems its raison d'etre is to not use templates     =>  Change `clone()` in Cloneable
        * Use `kvathupo/fix/sequential_clone`
    * Does TORCH_CHECK check after the loop?
    * Files to edit:
./torch/csrc/api/include/torch/nn/modules/container/sequential.h
    - Extends `ModuleHolder`, defined in `torch/csrc/api/include/torch/nn/pimpl.h`
    - Clones `std::vector<AnyModule> modules_` member variable, defined in `./torch/csrc/api/include/torch/nn/modules/container/any.h`.
Its `clone()` method calls the `clone_module()` function of its member variable `std::unique_ptr<AnyModulePlaceholder> content_`.
`AnyModulePlaceholder` is defined in `any_module_holder.h`. Its `clone_module()` method calls `clone()` on its 
`std::shared_ptr<ModuleType> module` member variable. `ModuleType` is some module that has a `forward()` method, i.e. an object of type `Module`.
__But,__ it should probably also have `Cloneable`.
    - `vim any.h sequential.h  ../../module.h ../../modules.h -p ../../pimpl.h`
./torch/csrc/api/include/torch/nn
### Current (Q's)
    * Why `std::move()` the string in `push_back(std::string, std::shared_ptr)`?
    * Replace fine-grained type checking via internal `structs` in `any_module_holder.h` with type traits
        * `torch::unpack()` is only used here? Can be replaced with the more canonical (and clearer) type traits (now concepts and constraints)
    * Move the fine-grained type-checking from internal structs and `unpack()` to type traits on the templates
### Current (Further Dev.)
    * C++17: 
        * Replace `torch/csrc/api/include/torch/nn/modules/container/any_value.h` with `std::any`
        * Replace `c10::nullopt`, deal with `c10::optional`
        * Add type traits functionality to check the typing of otherwise hard to understand template parameters in `class Sequential`
## To Do
    * Use ccmake and ninja

# Down the Road
    * In reference to: https://github.com/pytorch/pytorch/pull/89680/files
        * Do we need a `Py_DECREF` in there somewhere? Probably within the `load()` when we create a temporary variable.
        * See: [pybind doc](https://pybind11.readthedocs.io/en/stable/advanced/cast/custom.html), [testing pybind memory leaks](https://stackoverflow.com/questions/67110549/pybind11-identify-and-remove-memory-leak-in-c-wrapper), [unanswered](https://stackoverflow.com/questions/59707473/python-c-extension-how-to-test-reference-counting-and-memory-leaks)
    * Related issues:
        * https://github.com/pytorch/pytorch/issues/17249
        * https://github.com/pytorch/pytorch/issues/29065
        * https://github.com/pytorch/pytorch/issues/56786
    * Knock out a bunch of the `TODO`s in `c10::complex` with a non-sponsored PR.
        * `c10::conj`, `c10::proj` (`thrust::proj` exists now?)
        * Perhaps open a new issue or include in "further developments" of above PR
* Make a note that `constexpr` constructors should be implemented in Thrust 2.0 (https://github.com/NVIDIA/thrust/issues/1677#issuecomment-1115153416)

## SIMD
* In the `TODO`s here:
https://github.com/pytorch/pytorch/blob/4f34cd6d1e91dcd82ee30c3ea39bdb8a0fa93e8b/caffe2/sgd/ftrl_op.cc
