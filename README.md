<div align="center">

# asdf-grex ![Build](https://github.com/comdotlinux/asdf-grex/workflows/Build/badge.svg) ![Lint](https://github.com/comdotlinux/asdf-grex/workflows/Lint/badge.svg)

[grex](https://github.com/pemistahl/grex) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add grex
# or
asdf plugin add grex https://github.com/comdotlinux/asdf-grex.git
```

grex:

```shell
# Show all installable versions
asdf list-all grex

# Install specific version
asdf install grex latest

# Set a version globally (on your ~/.tool-versions file)
asdf global grex latest

# Now grex commands are available
grex --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/comdotlinux/asdf-grex/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Guruprasad Kulkarni](https://github.com/comdotlinux/)
