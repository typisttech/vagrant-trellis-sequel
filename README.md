# Vagrant Trellis Sequel

[![Gem](https://img.shields.io/gem/v/vagrant-trellis-sequel.svg)](https://rubygems.org/gems/vagrant-trellis-sequel)
[![Gem](https://img.shields.io/gem/dt/vagrant-trellis-sequel.svg)](https://rubygems.org/gems/vagrant-trellis-sequel)
[![Dependency Status](https://gemnasium.com/badges/github.com/TypistTech/vagrant-trellis-sequel.svg)](https://gemnasium.com/github.com/TypistTech/vagrant-trellis-sequel)
[![license](https://img.shields.io/github/license/TypistTech/vagrant-trellis-sequel.svg)](https://github.com/TypistTech/vagrant-trellis-sequel/blob/master/LICENSE)
[![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://www.typist.tech/donate/vagrant-trellis-sequel/)
[![Hire Typist Tech](https://img.shields.io/badge/Hire-Typist%20Tech-ff69b4.svg)](https://www.typist.tech/contact/)

Open Trellis databases in Sequel Pro with a single command

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Installation](#installation)
- [Usage](#usage)
  - [Noob](#noob)
  - [Specify which site's database](#specify-which-sites-database)
  - [Specify vault password file](#specify-vault-password-file)
  - [Specify vault password](#specify-vault-password)
- [Common Errors](#common-errors)
  - [DB password not found for `example_dev`](#db-password-not-found-for-example_dev)
  - [HMAC encoded in the file does not match calculated one](#hmac-encoded-in-the-file-does-not-match-calculated-one)
- [Connection Errors](#connection-errors)
  - [`key_load_public: No such file or directory`](#key_load_public-no-such-file-or-directory)
- [Support!](#support)
  - [Donate via PayPal *](#donate-via-paypal-)
  - [Why don't you hire me?](#why-dont-you-hire-me)
  - [Want to help in other way? Want to be a sponsor?](#want-to-help-in-other-way-want-to-be-a-sponsor)
- [Feedback](#feedback)
- [Change log](#change-log)
- [Credits](#credits)
- [Contributing](#contributing)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation

```bash
$ vagrant plugin install vagrant-trellis-sequel
```

## Usage

```bash
$ vagrant trellis-sequel open --help
Usage: vagrant trellis-sequel open [options] [vm-id]

        --site [site]                Site whose database going to be opened.
        --vault-password-file [VAULT_PASSWORD_FILE]
                                     Vault password file.
        --vault-pass [VAULT_PASS]    Vault password.
    -h, --help                       Print this help
```

### Noob

```bash
$ vagrant trellis-sequel open
```

This works for most of the cases:
  - `vault.yml` is unencrypted
  - `vault.yml` is encrypted and `.vault_pass` contains the vault password
  - running from within the Trellis directory

### Specify which site's database

```
$ vagrant trellis-sequel open --site example.com
```

Use the `--site` option to specify which site's database to open. By default, the first site's database will be opened.
Note: This is the site key of `vault_wordpress_sites` in `vault.yml`, usually ends with `.com`.

### Specify vault password file

```
$ vagrant trellis-sequel open --vault-password-file .my_vault_password_file
$ vagrant trellis-sequel open --vault-password-file /my/top/secret.txt
```

Use the `--vault-password-file` option to specify path to the vault password file, either relative path from Trellis root or absolute path.
Default value is `.vault_pass` if `vault.yml` is encrypted.

### Specify vault password

```
$ vagrant trellis-sequel open --vault-pass my-top-secret
```

Use the `--vault-pass` option to provide vault password if you encrypted `vault.yml` but don't have a vault password file.

## Common Errors

### DB password not found for `example_dev`

That means you passed wrong `--site` or `vault.yml` is malformed.

```yaml
# group_vars/development/vault.yml

vault_wordpress_sites:
  example.com:
    admin_password: admin
    env:
      db_password: bye
  www.typist.tech:
    admin_password: admin
    env:
      db_password: hello
```

For the above `vault.yml`, these 2 commands are valid:
```bash
$ vagrant trellis-sequel open --site example.com
$ vagrant trellis-sequel open --site www.typist.tech
```


### HMAC encoded in the file does not match calculated one

That means vault password is incorrect.

## Connection Errors

(This part is stolen from from [Sequel Pro for Chassis](https://github.com/Chassis/SequelPro/tree/b3236ca5205e34f6c2e135a9f1b8aa0f1686717b#connection-errors).)

If you get a connection error, the first thing to attempt to debug is to check the details that Sequel Pro gives you (under the Show Details button).

### `key_load_public: No such file or directory`

If you get this error on macOS Sierra, it's possible that you have too many SSH keys loaded into your `ssh-agent`. If you're using multiple boxes with [this setup in your SSH config](http://apple.stackexchange.com/a/264974/55070) (`AddKeysToAgent yes`), each new box you add will be added to your agent. With too many of these, SSH will hit the authentication retries limit before getting to the correct key.

The simple solution is to add this to your `~/.ssh/config` file:

```
  # Disable checks on Vagrant machines
  Host 127.0.0.1
    # Skip adding to agent
    AddKeysToAgent no

    # Only use key specified on CLI
    IdentitiesOnly yes

    # Skip known hosts
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
```

This disables using system-level keys (both from the agent, and your regular SSH keys), and disables host checks (which are not necessary for localhost). This does not affect `vagrant ssh`, which already uses these options.

## Support!

### Donate via PayPal [![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://www.typist.tech/donate/vagrant-trellis-sequel/)

Love Vagrant Trellis Sequel? Help me maintain it, a [donation here](https://www.typist.tech/donate/vagrant-trellis-sequel/) can help with it.

### Why don't you hire me?

Ready to take freelance WordPress jobs. Contact me via the contact form [here](https://www.typist.tech/contact/) or, via email [info@typist.tech](mailto:info@typist.tech)

### Want to help in other way? Want to be a sponsor?

Contact: [Tang Rufus](mailto:tangrufus@gmail.com)

## Feedback

**Please provide feedback!** We want to make this library useful in as many projects as possible.
Please submit an [issue](https://github.com/TypistTech/vagrant-trellis-sequel/issues/new) and point out what you do and don't like, or fork the project and make suggestions.
**No issue is too small.**

## Change log

Please see [CHANGELOG](./CHANGELOG.md) for more information on what has changed recently.

## Credits

[Vagrant Trellis Sequel](https://github.com/TypistTech/vagrant-trellis-sequel) is a [Typist Tech](https://www.typist.tech) project and maintained by [Tang Rufus](https://twitter.com/Tangrufus), freelance developer for [hire](https://www.typist.tech/contact/).

Inspired from [Sequel Pro for Chassis](https://github.com/Chassis/SequelPro).

Special thanks to [the Roots team](https://roots.io/about/) whose [Trellis](https://github.com/roots/trellis) make this project possible.

Full list of contributors can be found [here](https://github.com/TypistTech/vagrant-trellis-sequel/graphs/contributors).

## Contributing

Please see [CODE_OF_CONDUCT](./CODE_OF_CONDUCT.md) for details.

## License

[Vagrant Trellis Sequel](https://github.com/TypistTech/vagrant-trellis-sequel) is released under the [MIT License](https://opensource.org/licenses/MIT).
