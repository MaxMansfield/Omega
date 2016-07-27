# Apollo
#### Version: omega (v0.1.2)
<br/>
<hr/>
Apollo is a small x86_64 kernel written in rust
<hr/>
<br/>


# Build Dependencies

Below is a list of things you need to run the kernel and some instructions.
If you want to know the kernel dependencies please look at the [Vagrantfile](https://github.com/MaxMansfield/apollo/blob/master/Vagrantfile)
and [Cargo.toml](https://github.com/MaxMansfield/apollo/blob/master/Cargo.toml) for now since they change so frequently at this stage
in development.

##### All
* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

##### OS X
* [XQuartz](https://www.xquartz.org/)

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
  git clone https://github.com/MaxMansfield/apollo.git     # Get the kernel
  cd apollo                                                # Go to the kernel
  vagrant up --provider=virtualBox                         # Get Dev Environment
  vagrant ssh                                              # Go to Dev Environment
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
the bottom of the [Vagrantfile](https://github.com/MaxMansfield/apollo/blob/master/Vagrantfile) for the `sh` instructions used to install dependencies and set `rustup` to a default `nightly` build.

<br/>
<br/>

# Contributors and Resources
##### 1. **Philipp Oppermann** for [his amazing site](http://os.phil-opp.com/)
##### 2. **intermezzOS** for [their thourough walkthrough](http://intermezzos.github.io/) 
##### 2. **Ashley Williams** and [her x86 repo](https://github.com/ashleygwilliams/x86-kernel) for showing me Vagrant

# License (MIT)
##### See the file named [LICENSE](https://github.com/MaxMansfield/apollo/blob/master/LICENSE) at the root directory of this repository.

<br/>
<br/>
