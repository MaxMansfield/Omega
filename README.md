# Apollo
#### Version: omega (v0.1.0)
<br/>
<br/>
<hr/>
Apollo is a small x86 kernel written in rust and assembly
<hr/>
<br/>

# Build Dependencies

Below is a list of things you need to run the kernel and some instructions.
If you want to know the kernel dependencies please look at the `Vagrantfile`
and `Cargo.toml` for now since they change so frequently at this stage
in development.

##### All
* Vagrant
* VirtualBox

##### OS X
* XQuartz

##### Windows
* [Read This](https://help.ubuntu.com/community/SwitchingToUbuntu/FromWindows)

<br/>
<br/>

# Build Parameters
You can also give different parameters to the build system
###### `arch` x86_64
      The architecture to build for. Currently only x86_64 is supported.
###### `build`  release,debug
        The build type (debug/release) passed to `nasm` and `cargo`
###### `target` x86_64-unknown-linux-gnu
        The target to use for compilers. Currently only linux is supported.
###### `version` [x.x.x]
      The semantic version of the build.
###### `name` [Version name]
      The name of the build. Should only be changed on major version changes.

##### Parameter example
```sh
  # This example could be something used in the future
  make iso name=upsilon version=2.3.12 build=release
```
<br/>
<br/>

# Build and Run
#### 1. Install `vagrant` and `virtualbox` (as well as `xquartz` if you are on OS X)
```sh
  git clone https://github.com/MaxMansfield/omega.git     # Get the kernel
  cd omega                                                # Go to the kernel
  vagrant up --provider=virtualBox                        # Get Dev Environment
  vagrant ssh                                             # Go to Dev Environment
```
#### 2. Now that you are `ssh`'d into the system navigate to the share folder
```sh
  cd /vagrant       # Where the parent dir of the Vagrantfile is mapped
```
#### 3. Make sure to always `clean` the project first.
```sh
  make clean      # Don't forget to wash your hands before you eat!
```
#### 4. Now you can build and run the kernel!
```sh
  make            # Just builds the program
  make iso        # builds if needed and outputs an iso Image
  make run        # does all of the above and opens a qemu instance
  make clean      # Ready to commit!
```
<br/>
<br/>


# Without `Vagrant`
If you would like to build this without `vagrant` then take a look at the
the bottom of the `Vagrantfile` for the `sh` instructions used to install
dependencies and set `rustup` to a default `nightly` build.

<br/>
<br/>

# License (MIT)
##### See the file name `LICENSE` at the root directory of this repository.

<br/>
<br/>

# Contributors
##### 1. Thank you to **Philipp Oppermann** for [his amazing site](http://os.phil-opp.com/) from which this kernel was made.
##### 2. Thank you to **Ashley Williams** and [her x86 repo](https://github.com/ashleygwilliams/x86-kernel) for showing me Vagrant
