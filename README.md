<div align="center">

# asdf-launchpad [![Build](https://github.com/surskitt/asdf-launchpad/actions/workflows/build.yml/badge.svg)](https://github.com/surskitt/asdf-launchpad/actions/workflows/build.yml) [![Lint](https://github.com/surskitt/asdf-launchpad/actions/workflows/lint.yml/badge.svg)](https://github.com/surskitt/asdf-launchpad/actions/workflows/lint.yml)

[launchpad](https://docs.mirantis.com/mke/3.7/launchpad.html) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add launchpad
# or
asdf plugin add launchpad https://github.com/surskitt/asdf-launchpad.git
```

launchpad:

```shell
# Show all installable versions
asdf list-all launchpad

# Install specific version
asdf install launchpad latest

# Set a version globally (on your ~/.tool-versions file)
asdf global launchpad latest

# Now launchpad commands are available
launchpad version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/surskitt/asdf-launchpad/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [surskitt](https://github.com/surskitt/)
