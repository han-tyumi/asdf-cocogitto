<div align="center">

# asdf-cocogitto [![Build](https://github.com/han-tyumi/asdf-cocogitto/actions/workflows/build.yml/badge.svg)](https://github.com/han-tyumi/asdf-cocogitto/actions/workflows/build.yml) [![Lint](https://github.com/han-tyumi/asdf-cocogitto/actions/workflows/lint.yml/badge.svg)](https://github.com/han-tyumi/asdf-cocogitto/actions/workflows/lint.yml)

[cocogitto](https://docs.cocogitto.io/) plugin for the [asdf version manager](https://asdf-vm.com).

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
asdf plugin add cocogitto
# or
asdf plugin add cocogitto https://github.com/han-tyumi/asdf-cocogitto.git
```

cocogitto:

```shell
# Show all installable versions
asdf list-all cocogitto

# Install specific version
asdf install cocogitto latest

# Set a version globally (on your ~/.tool-versions file)
asdf global cocogitto latest

# Now cocogitto commands are available
cocogitto --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/han-tyumi/asdf-cocogitto/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Matt Champagne](https://github.com/han-tyumi/)
